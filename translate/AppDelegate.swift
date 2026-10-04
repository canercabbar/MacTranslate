//
//  AppDelegate.swift
//  translate
//

import Cocoa

/// Main application lifecycle delegate managing the menu bar status item and floating translation panel.
final class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Properties
    
    /// The floating translation panel window.
    private(set) var panel: FloatingPanel!
    
    /// The status bar item residing in the macOS menu bar.
    private var statusItem: NSStatusItem!

    // MARK: - NSApplicationDelegate
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupFloatingPanel()
        setupStatusItem()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    // MARK: - Setup
    
    private func setupFloatingPanel() {
        panel = FloatingPanel()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        guard let button = statusItem.button else { return }
        
        let icon = NSImage(named: "icon")
        icon?.isTemplate = true
        button.image = icon
        button.action = #selector(handleStatusItemClick)
        button.target = self
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }

    // MARK: - Actions
    
    @objc private func handleStatusItemClick() {
        guard let currentEvent = NSApp.currentEvent else { return }
        
        if currentEvent.type == .rightMouseUp {
            presentContextMenu()
        } else {
            panel.toggle()
        }
    }
    
    private func presentContextMenu() {
        let menu = NSMenu()
        let quitMenuItem = NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        menu.addItem(quitMenuItem)
        
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }
}
