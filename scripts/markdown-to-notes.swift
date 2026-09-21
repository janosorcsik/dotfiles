#!/usr/bin/env swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Markdown to Notes
// @raycast.mode silent

// Optional parameters:
// @raycast.icon 📋
// @raycast.description Convert clipboard Markdown to Apple Notes HTML. Paste with ⌘V.

import Foundation
import AppKit

private let enDash = "\u{2013}"
private let nbsp   = "\u{00A0}"
private let indent = String(repeating: nbsp, count: 4)

private func escapeHtml(_ s: String) -> String {
    s.replacingOccurrences(of: "&",  with: "&amp;")
     .replacingOccurrences(of: "<",  with: "&lt;")
     .replacingOccurrences(of: ">",  with: "&gt;")
     .replacingOccurrences(of: "\"", with: "&quot;")
}

private func normalizeDividers(_ md: String) -> String {
    let fenceRe = try! NSRegularExpression(pattern: #"^ {0,3}(`{3,}|~{3,})"#)
    let breakRe = try! NSRegularExpression(
        pattern: #"^ {0,3}(?:(?:-[ \t]*){3,}|(?:\*[ \t]*){3,}|(?:_[ \t]*){3,})$"#)
    var out: [String] = []
    var inFence = false
    var fenceChar: Character = "`"
    for line in md.components(separatedBy: "\n") {
        let range = NSRange(line.startIndex..., in: line)
        if let m = fenceRe.firstMatch(in: line, range: range) {
            let ch = (line as NSString).substring(with: m.range(at: 1)).first!
            if !inFence { inFence = true; fenceChar = ch }
            else if ch == fenceChar { inFence = false }
            out.append(line)
            continue
        }
        if !inFence,
           breakRe.firstMatch(in: line, range: range) != nil,
           out.last.map({ !$0.trimmingCharacters(in: .whitespaces).isEmpty }) == true {
            out.append("")
        }
        out.append(line)
    }
    return out.joined(separator: "\n")
}

private enum BlockKind: Equatable {
    case paragraph
    case header(level: Int)
    case codeBlock
    case blockquote
    case hr
    case listItem(depth: Int, ordered: Bool, ordinal: Int)
    case table
}

private struct MdRun {
    let text: String
    let inlineIntent: InlinePresentationIntent?
    let link: URL?
    let kind: BlockKind
    let groupId: Int
    let listItemId: Int
    let tableGroupId: Int
    let isTableHeaderRow: Bool
    let tableRow: Int
    let tableCol: Int
}

private func parseRuns(_ attr: AttributedString) -> [MdRun] {
    attr.runs.compactMap { run in
        let text = String(attr[run.range].characters)
        guard !text.isEmpty else { return nil }

        var kind: BlockKind = .paragraph
        var groupId = 0, listItemId = 0
        var listDepth = 0, listOrdered = false, listOrdinal = 1
        var tableGroupId = -1, isTableHeaderRow = false, tableRow = -1, tableCol = -1

        for comp in run.presentationIntent?.components ?? [] {
            switch comp.kind {
            case .paragraph:
                if kind == .paragraph { groupId = comp.identity }
            case .header(let l):
                kind = .header(level: l); groupId = comp.identity
            case .codeBlock:
                kind = .codeBlock; groupId = comp.identity
            case .blockQuote:
                kind = .blockquote; groupId = comp.identity
            case .thematicBreak:
                kind = .hr; groupId = comp.identity
            case .listItem(let o):
                kind = .listItem(depth: 0, ordered: false, ordinal: o)
                if listItemId == 0 { listOrdinal = o; listItemId = comp.identity }
            case .unorderedList:
                listDepth += 1; listOrdered = false; groupId = comp.identity
            case .orderedList:
                listDepth += 1; listOrdered = true; groupId = comp.identity
            case .table:
                kind = .table; tableGroupId = comp.identity; groupId = comp.identity
            case .tableHeaderRow:
                isTableHeaderRow = true; tableRow = 0
            case .tableRow(let r):
                tableRow = r
            case .tableCell(let c):
                tableCol = c
            default:
                break
            }
        }

        if case .listItem = kind {
            kind = .listItem(depth: max(0, listDepth - 1), ordered: listOrdered, ordinal: listOrdinal)
        }

        return MdRun(
            text: text,
            inlineIntent: run.inlinePresentationIntent,
            link: run.link,
            kind: kind,
            groupId: groupId,
            listItemId: listItemId,
            tableGroupId: tableGroupId,
            isTableHeaderRow: isTableHeaderRow,
            tableRow: tableRow,
            tableCol: tableCol
        )
    }
}

private func renderInline(_ r: MdRun) -> String {
    guard r.inlineIntent?.contains(.softBreak) != true,
          r.inlineIntent?.contains(.lineBreak)  != true else { return " " }
    var t = escapeHtml(r.text)
    if let il = r.inlineIntent {
        if il.contains(.stronglyEmphasized) { t = "<b>\(t)</b>" }
        else if il.contains(.emphasized)    { t = "<i>\(t)</i>" }
        if il.contains(.code)               { t = "<tt>\(t)</tt>" }
        if il.contains(.strikethrough)      { t = "<s>\(t)</s>" }
    }
    if let url = r.link { t = "<a href=\"\(url.absoluteString)\">\(t)</a>" }
    return t
}

private func markdownParsingOptions() -> AttributedString.MarkdownParsingOptions {
    var opts = AttributedString.MarkdownParsingOptions()
    opts.interpretedSyntax = .full
    opts.allowsExtendedAttributes = true
    return opts
}

func toNotesHtml(_ markdown: String) -> String {
    guard let attr = try? AttributedString(markdown: normalizeDividers(markdown), options: markdownParsingOptions()) else {
        return "<div>\(escapeHtml(markdown))</div>"
    }

    let runs = parseRuns(attr)
    var blocks: [String] = []
    var groupId = -1, groupKind = BlockKind.paragraph, groupRuns: [MdRun] = []
    var itemId = -1, itemRuns: [MdRun] = []
    var tableId = -1, tableRows: [Int: [Int: String]] = [:]
    var tableHeader = false, maxRow = 0, maxCol = 0

    func flushItem() {
        guard !itemRuns.isEmpty, case let .listItem(depth, ordered, ordinal) = itemRuns[0].kind else { return }
        let prefix = String(repeating: indent, count: depth) + (ordered ? "\(ordinal)." : enDash) + nbsp
        blocks.append("<div>\(prefix)\(itemRuns.map(renderInline).joined())</div>")
        itemRuns = []; itemId = -1
    }

    func flushTable() {
        guard tableId != -1 else { return }
        let rows = (0...maxRow).map { row in
            let cells = (0...maxCol).map { col -> String in
                let cell = tableRows[row]?[col] ?? ""
                return (row == 0 && tableHeader) ? "<th>\(cell)</th>" : "<td>\(cell)</td>"
            }.joined()
            return "<tr>\(cells)</tr>"
        }.joined()
        blocks.append("<table>\(rows)</table>")
        tableRows = [:]; tableHeader = false; maxRow = 0; maxCol = 0; tableId = -1
    }

    func flushGroup() {
        guard !groupRuns.isEmpty else { return }
        defer { groupRuns = []; groupId = -1 }
        switch groupKind {
        case .header(let level):
            let tag = level == 1 ? "h1" : level == 2 ? "h2" : "h3"
            blocks.append("<div><\(tag)>\(groupRuns.map(renderInline).joined())</\(tag)></div>")
        case .hr:
            break
        case .codeBlock:
            blocks.append("<pre>\(escapeHtml(groupRuns.map(\.text).joined()))</pre>")
        default:
            let inner = groupRuns.map(renderInline).joined().trimmingCharacters(in: .whitespacesAndNewlines)
            if !inner.isEmpty { blocks.append("<div>\(inner)</div>") }
        }
    }

    for r in runs {
        switch r.kind {
        case .listItem:
            flushGroup(); flushTable()
            if r.listItemId != itemId { flushItem(); itemId = r.listItemId }
            itemRuns.append(r)
        case .table:
            flushGroup(); flushItem()
            if r.tableGroupId != tableId { flushTable(); tableId = r.tableGroupId }
            if r.tableRow >= 0, r.tableCol >= 0 {
                tableRows[r.tableRow, default: [:]][r.tableCol, default: ""] += renderInline(r)
                if r.isTableHeaderRow { tableHeader = true }
                maxRow = max(maxRow, r.tableRow)
                maxCol = max(maxCol, r.tableCol)
            }
        default:
            flushItem(); flushTable()
            if r.groupId != groupId { flushGroup(); groupId = r.groupId; groupKind = r.kind }
            groupRuns.append(r)
        }
    }
    flushItem(); flushTable(); flushGroup()

    return blocks.joined(separator: "<div><br></div>")
}

func toPlainText(_ markdown: String) -> String {
    guard let attr = try? AttributedString(markdown: normalizeDividers(markdown), options: markdownParsingOptions()) else {
        return markdown
    }
    let runs = parseRuns(attr)
    var lines: [String] = []
    var itemId = -1, itemLine = ""
    var groupId = -1, groupBuf = ""

    func flushItem()  { if !itemLine.isEmpty { lines.append(itemLine); itemLine = ""; itemId  = -1 } }
    func flushGroup() { if !groupBuf.isEmpty { lines.append(groupBuf); groupBuf = ""; groupId = -1 } }

    for r in runs {
        let isSoft = r.inlineIntent?.contains(.softBreak) == true || r.inlineIntent?.contains(.lineBreak) == true
        switch r.kind {
        case .hr:
            continue
        case .listItem(let depth, let ordered, let ordinal):
            flushGroup()
            if r.listItemId != itemId {
                flushItem(); itemId = r.listItemId
                itemLine = "\(String(repeating: "  ", count: depth))\(ordered ? "\(ordinal)." : "-") "
            }
            itemLine += isSoft ? " " : r.text
        default:
            flushItem()
            if r.groupId != groupId { flushGroup(); groupId = r.groupId }
            groupBuf += isSoft ? " " : r.text
        }
    }
    flushItem(); flushGroup()

    return lines.joined(separator: "\n\n")
        .replacingOccurrences(of: "\n{3,}", with: "\n\n", options: .regularExpression, range: nil)
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

guard let markdown = NSPasteboard.general.string(forType: .string),
      !markdown.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
    exit(0)
}

let pb = NSPasteboard.general
pb.clearContents()
pb.setString("<meta charset=\"utf-8\">" + toNotesHtml(markdown), forType: .html)
pb.setString(toPlainText(markdown), forType: .string)
