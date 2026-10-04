//
//  WebView.swift
//  translate
//

import WebKit

/// A specialized `WKWebView` that forwards window drag events and standard macOS edit shortcuts.
final class WebView: WKWebView {
    
    // MARK: - Key Equivalents
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        guard event.type == .keyDown else {
            return super.performKeyEquivalent(with: event)
        }
        
        let modifierFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        
        // Handle standard Command (⌘) shortcuts inside the web view
        if modifierFlags == .command, let characters = event.charactersIgnoringModifiers {
            switch characters {
            case "z":
                if NSApp.sendAction(Selector(("undo:")), to: nil, from: self) { return true }
            case "r":
                if NSApp.sendAction(Selector(("redo:")), to: nil, from: self) { return true }
            case "x":
                if NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: self) { return true }
            case "c":
                if NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: self) { return true }
            case "v":
                if NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: self) { return true }
            default:
                break
            }
        }
        
        return super.performKeyEquivalent(with: event)
    }
    
    // MARK: - Drag & Mouse Event Forwarding
    
    override func mouseDragged(with event: NSEvent) {
        window?.performDrag(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        window?.mouseUp(with: event)
    }
}
