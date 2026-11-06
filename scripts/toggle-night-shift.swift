#!/usr/bin/env swift

// @raycast.schemaVersion 1
// @raycast.title Toggle Night Shift
// @raycast.mode silent
// @raycast.icon 🌙

import Foundation

guard dlopen("/System/Library/PrivateFrameworks/CoreBrightness.framework/CoreBrightness", RTLD_LAZY) != nil,
      let cls = NSClassFromString("CBBlueLightClient") as? NSObject.Type
else {
    print("CoreBrightness unavailable")
    exit(1)
}

let client = cls.init()
let getStatus = unsafeBitCast(
    client.method(for: NSSelectorFromString("getBlueLightStatus:")),
    to: (@convention(c) (AnyObject, Selector, UnsafeMutableRawPointer) -> Bool).self
)
let setEnabled = unsafeBitCast(
    client.method(for: NSSelectorFromString("setEnabled:")),
    to: (@convention(c) (AnyObject, Selector, Bool) -> Bool).self
)

let status = UnsafeMutableRawPointer.allocate(byteCount: 64, alignment: 8)
status.initializeMemory(as: UInt8.self, repeating: 0, count: 64)
_ = getStatus(client, NSSelectorFromString("getBlueLightStatus:"), status)
let enabled = status.load(fromByteOffset: 1, as: Bool.self)
_ = setEnabled(client, NSSelectorFromString("setEnabled:"), !enabled)
