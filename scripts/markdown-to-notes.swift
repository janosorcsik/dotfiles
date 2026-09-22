#!/usr/bin/env swift

// @raycast.schemaVersion 1
// @raycast.title Markdown to Notes
// @raycast.mode silent
// @raycast.icon 📋
// @raycast.description Convert clipboard Markdown to Apple Notes HTML. Paste with ⌘V.

import Foundation
import AppKit

private let enDash = "\u{2013}"
private let nbsp = "\u{00A0}"
private let indent = String(repeating: nbsp, count: 4)

private func escapeHtml(_ s: String) -> String {
    s.replacingOccurrences(of: "&", with: "&amp;")
        .replacingOccurrences(of: "<", with: "&lt;")
        .replacingOccurrences(of: ">", with: "&gt;")
        .replacingOccurrences(of: "\"", with: "&quot;")
}

private func normalizeDividers(_ md: String) -> String {
    let fenceRe = try! NSRegularExpression(pattern: #"^ {0,3}(`{3,}|~{3,})"#)
    let breakRe = try! NSRegularExpression(
        pattern: #"^ {0,3}(?:(?:-[ \t]*){3,}|(?:\*[ \t]*){3,}|(?:_[ \t]*){3,})$"#)
    var out: [String] = []
    var fence: Character?
    for line in md.components(separatedBy: "\n") {
        let range = NSRange(line.startIndex..., in: line)
        if let m = fenceRe.firstMatch(in: line, range: range) {
            let ch = (line as NSString).substring(with: m.range(at: 1)).first!
            fence = (fence == nil) ? ch : (fence == ch ? nil : fence)
        } else if fence == nil,
                  breakRe.firstMatch(in: line, range: range) != nil,
                  out.last?.trimmingCharacters(in: .whitespaces).isEmpty == false {
            out.append("")
        }
        out.append(line)
    }
    return out.joined(separator: "\n")
}

private struct Block {
    enum Kind: Equatable {
        case paragraph
        case header(Int)
        case codeBlock
        case listItem(depth: Int, ordered: Bool, ordinal: Int)
        case tableCell(row: Int, col: Int, isHeader: Bool)
        case skip
    }
    var kind: Kind = .paragraph
    var id = 0
    var container: Int?
}

private struct MdRun {
    let text: String
    let inline: InlinePresentationIntent?
    let link: URL?
    let block: Block
}

private func classify(_ intent: PresentationIntent?) -> Block {
    var b = Block()
    var depth = 0, ordered = false, ordinal = 1, markerSet = false
    var listItemId: Int?, tableId: Int?
    var row = -1, col = -1, isHeaderRow = false

    for c in intent?.components ?? [] {
        switch c.kind {
        case .paragraph:
            b.id = c.identity
        case .header(let l):
            b.kind = .header(min(l, 3))
            b.id = c.identity
        case .codeBlock:
            b.kind = .codeBlock
            b.id = c.identity
        case .thematicBreak:
            b.kind = .skip
            b.id = c.identity
        case .listItem(let o):
            if listItemId == nil {
                listItemId = c.identity
                ordinal = o
            }
        case .unorderedList:
            depth += 1
            if !markerSet {
                ordered = false
                markerSet = true
            }
            b.container = c.identity
        case .orderedList:
            depth += 1
            if !markerSet {
                ordered = true
                markerSet = true
            }
            b.container = c.identity
        case .table:
            tableId = c.identity
        case .tableHeaderRow:
            isHeaderRow = true
            row = 0
        case .tableRow(let r):
            row = r
        case .tableCell(let c):
            col = c
        default:
            break
        }
    }

    if let t = tableId {
        b.kind = .tableCell(row: row, col: col, isHeader: isHeaderRow)
        b.id = t
    } else if let i = listItemId {
        b.kind = .listItem(depth: max(0, depth - 1), ordered: ordered, ordinal: ordinal)
        b.id = i
    }
    return b
}

private func parse(_ markdown: String) -> [[MdRun]] {
    var opts = AttributedString.MarkdownParsingOptions()
    opts.interpretedSyntax = .full
    opts.allowsExtendedAttributes = true

    guard let attr = try? AttributedString(markdown: normalizeDividers(markdown), options: opts)
    else { return [] }

    var chunks: [[MdRun]] = []
    for run in attr.runs {
        let text = String(attr[run.range].characters)
        guard !text.isEmpty else { continue }

        let md = MdRun(
            text: text,
            inline: run.inlinePresentationIntent,
            link: run.link,
            block: classify(run.presentationIntent)
        )

        if chunks.last?.first?.block.id == md.block.id {
            chunks[chunks.count - 1].append(md)
        } else {
            chunks.append([md])
        }
    }
    return chunks
}

private func isBreak(_ r: MdRun) -> Bool {
    r.inline?.contains(.softBreak) == true || r.inline?.contains(.lineBreak) == true
}

private func assemble(_ chunks: [[MdRun]], gap: String, tight: String,
                      render: ([MdRun]) -> String?) -> String {
    var out = ""
    var previous: Int??
    for chunk in chunks {
        guard let first = chunk.first, let body = render(chunk) else { continue }
        if let prev = previous {
            let sameList = first.block.container != nil && first.block.container == prev
            out += sameList ? tight : gap
        }
        out += body
        previous = first.block.container
    }
    return out
}

private func inlineHtml(_ r: MdRun) -> String {
    guard !isBreak(r) else { return " " }

    var t = escapeHtml(r.text)
    if let il = r.inline {
        if il.contains(.stronglyEmphasized) {
            t = "<b>\(t)</b>"
        } else if il.contains(.emphasized) {
            t = "<i>\(t)</i>"
        }

        if il.contains(.code) {
            t = "<tt>\(t)</tt>"
        }

        if il.contains(.strikethrough) {
            t = "<s>\(t)</s>"
        }
    }

    if let url = r.link {
        t = "<a href=\"\(escapeHtml(url.absoluteString))\">\(t)</a>"
    }
    return t
}

private func tableHtml(_ chunk: [MdRun]) -> String? {
    var grid: [Int: [Int: String]] = [:]
    var headerRows: Set<Int> = []
    for r in chunk {
        guard case let .tableCell(row, col, isHeader) = r.block.kind, row >= 0, col >= 0 else { continue }
        grid[row, default: [:]][col, default: ""] += inlineHtml(r)
        if isHeader { headerRows.insert(row) }
    }
    guard let maxRow = grid.keys.max(), let maxCol = grid.values.compactMap({ $0.keys.max() }).max()
    else { return nil }

    let rows = (0...maxRow).map { row -> String in
        let tag = headerRows.contains(row) ? "th" : "td"
        let cells = (0...maxCol).map { "<\(tag)>\(grid[row]?[$0] ?? "")</\(tag)>" }.joined()
        return "<tr>\(cells)</tr>"
    }.joined()
    return "<table>\(rows)</table>"
}

private func blockHtml(_ chunk: [MdRun]) -> String? {
    guard let kind = chunk.first?.block.kind else { return nil }

    switch kind {
    case .skip:
        return nil
    case .header(let level):
        return "<div><h\(level)>\(chunk.map(inlineHtml).joined())</h\(level)></div>"
    case .codeBlock:
        return "<pre>\(escapeHtml(chunk.map(\.text).joined()))</pre>"
    case .listItem(let depth, let ordered, let ordinal):
        let prefix = String(repeating: indent, count: depth) + (ordered ? "\(ordinal)." : enDash) + nbsp
        return "<div>\(prefix)\(chunk.map(inlineHtml).joined())</div>"
    case .tableCell:
        return tableHtml(chunk)
    case .paragraph:
        let inner = chunk.map(inlineHtml).joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return inner.isEmpty ? nil : "<div>\(inner)</div>"
    }
}

func toNotesHtml(_ markdown: String) -> String {
    let chunks = parse(markdown)
    guard !chunks.isEmpty else { return "<div>\(escapeHtml(markdown))</div>" }
    return assemble(chunks, gap: "<div><br></div>", tight: "", render: blockHtml)
}

private func blockText(_ chunk: [MdRun]) -> String? {
    guard let kind = chunk.first?.block.kind else { return nil }

    switch kind {
    case .skip:
        return nil
    case .listItem(let depth, let ordered, let ordinal):
        let text = chunk.map { isBreak($0) ? " " : $0.text }.joined()
        return String(repeating: "  ", count: depth) + (ordered ? "\(ordinal)." : "-") + " " + text
    case .tableCell:
        return nil
    default:
        let text = chunk.map { isBreak($0) ? " " : $0.text }.joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return text.isEmpty ? nil : text
    }
}

func toPlainText(_ markdown: String) -> String {
    let chunks = parse(markdown)
    guard !chunks.isEmpty else { return markdown }
    return assemble(chunks, gap: "\n\n", tight: "\n", render: blockText)
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
