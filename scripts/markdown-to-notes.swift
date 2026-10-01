#!/usr/bin/env swift

// @raycast.schemaVersion 1
// @raycast.title Markdown to Notes
// @raycast.mode silent
// @raycast.icon 📋
// @raycast.description Convert clipboard Markdown to Apple Notes HTML. Paste with ⌘V.

import AppKit
import Foundation

private let enDash = "\u{2013}"
private let nbsp = "\u{00A0}"
private let indent = String(repeating: nbsp, count: 4)

private func escapeHtml(_ s: String) -> String {
    s.reduce(into: "") { out, c in
        switch c {
        case "&": out += "&amp;"
        case "<": out += "&lt;"
        case ">": out += "&gt;"
        case "\"": out += "&quot;"
        default: out.append(c)
        }
    }
}

private func normalizeDividers(_ md: String) -> String {
    let fenceRe = #/ {0,3}(`{3,}|~{3,})/#
    let breakRe = #/ {0,3}(?:(?:-[ \t]*){3,}|(?:\*[ \t]*){3,}|(?:_[ \t]*){3,})\r?/#
    var out: [String] = []
    var fence: Character?
    for line in md.components(separatedBy: "\n") {
        if let m = line.prefixMatch(of: fenceRe) {
            let ch = m.1.first!
            if fence == nil { fence = ch } else if fence == ch { fence = nil }
        } else if fence == nil,
            line.wholeMatch(of: breakRe) != nil,
            out.last?.allSatisfy(\.isWhitespace) == false
        {
            out.append("")
        }
        out.append(line)
    }
    return out.joined(separator: "\n")
}

private struct Block {
    enum Kind {
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
    var depth = 0
    var ordered = false
    var ordinal = 1
    var listItemId: Int?
    var tableId: Int?
    var row = -1
    var col = -1
    var isHeaderRow = false

    for c in intent?.components ?? [] {
        switch c.kind {
        case .paragraph:
            b.id = c.identity
        case .header(let level):
            b.kind = .header(min(level, 3))
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
        case .unorderedList, .orderedList:
            if depth == 0 { ordered = c.kind == .orderedList }
            depth += 1
            b.container = c.identity
        case .table:
            tableId = c.identity
        case .tableHeaderRow:
            isHeaderRow = true
            row = 0
        case .tableRow(let r):
            row = r
        case .tableCell(let column):
            col = column
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
    guard
        let attr = try? AttributedString(
            markdown: normalizeDividers(markdown), options: .init(interpretedSyntax: .full))
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
    r.inline?.isDisjoint(with: [.softBreak, .lineBreak]) == false
}

private func assemble(
    _ chunks: [[MdRun]], gap: String, tight: String,
    render: ([MdRun]) -> String?
) -> String {
    var out = ""
    var prev: Int?
    for chunk in chunks {
        guard let first = chunk.first, let body = render(chunk) else { continue }
        let container = first.block.container
        if !out.isEmpty { out += (container != nil && container == prev) ? tight : gap }
        out += body
        prev = container
    }
    return out
}

private func inlineHtml(_ r: MdRun) -> String {
    guard !isBreak(r) else { return " " }

    var t = escapeHtml(r.text)
    if let il = r.inline {
        if il.contains(.emphasized) {
            t = "<i>\(t)</i>"
        }
        if il.contains(.stronglyEmphasized) {
            t = "<b>\(t)</b>"
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
        guard case .tableCell(let row, let col, let isHeader) = r.block.kind, row >= 0, col >= 0
        else { continue }
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
        let prefix =
            String(repeating: indent, count: depth)
            + (ordered ? "\(ordinal)." : enDash) + nbsp
        return "<div>\(prefix)\(chunk.map(inlineHtml).joined())</div>"
    case .tableCell:
        return tableHtml(chunk)
    case .paragraph:
        let inner = chunk.map(inlineHtml).joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return inner.isEmpty ? nil : "<div>\(inner)</div>"
    }
}

private func blockText(_ chunk: [MdRun]) -> String? {
    guard let kind = chunk.first?.block.kind else { return nil }
    let text = chunk.map { isBreak($0) ? " " : $0.text }.joined()

    switch kind {
    case .skip, .tableCell:
        return nil
    case .listItem(let depth, let ordered, let ordinal):
        return String(repeating: "  ", count: depth)
            + (ordered ? "\(ordinal)." : "-") + " " + text
    default:
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}

let pb = NSPasteboard.general

guard let markdown = pb.string(forType: .string), !markdown.allSatisfy(\.isWhitespace)
else { exit(0) }

private let chunks = parse(markdown)
let html =
    chunks.isEmpty
    ? "<div>\(escapeHtml(markdown))</div>"
    : assemble(chunks, gap: "<div><br></div>", tight: "", render: blockHtml)
let plain =
    chunks.isEmpty
    ? markdown
    : assemble(chunks, gap: "\n\n", tight: "\n", render: blockText)
        .trimmingCharacters(in: .whitespacesAndNewlines)

pb.clearContents()
pb.setString("<meta charset=\"utf-8\">" + html, forType: .html)
pb.setString(plain, forType: .string)
