//
//  FloatingPanel.swift
//  translate
//

import AppKit

/// A custom borderless, floating panel that can appear over any active application.
final class FloatingPanel: NSPanel {
    
    // MARK: - Properties
    
    /// Tracks whether the panel is currently displayed.
    private(set) var isPresented = false
    
    /// Indicates if the panel is currently being dragged by the user.
    private var isDragging = false
    
    /// Global event monitor for outside clicks to auto-dismiss the panel.
    private var outsideClickMonitor: Any?
    
    // MARK: - Initializer
    
    init() {
        let styleMask: NSWindow.StyleMask = [
            .nonactivatingPanel,
            .resizable,
            .titled,
            .closable,
            .fullSizeContentView
        ]
        
        super.init(contentRect: .zero, styleMask: styleMask, backing: .buffered, defer: false)
        
        setupPanelProperties()
    }
    
    // MARK: - Setup
    
    private func setupPanelProperties() {
        level = .floating
        isFloatingPanel = true
        isMovableByWindowBackground = true
        contentViewController = ViewController()
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        backgroundColor = .clear
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        
        contentView?.wantsLayer = true
        contentView?.layer?.cornerRadius = Constants.Window.cornerRadius
        
        // Hide standard window control buttons
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        
        center()
    }
    
    // MARK: - Panel Presentation & Dismissal
    
    /// Toggles the panel visibility. If open and focused, closes it; otherwise displays and focuses it.
    func toggle() {
        guard let controller = contentViewController as? ViewController else { return }
        
        if isPresented {
            if isKeyWindow {
                hidePanel()
            } else {
                makeKey()
                controller.focusAndSelectInputField()
            }
        } else {
            showPanel()
        }
    }
    
    /// Shows the panel and focuses the input field.
    func showPanel() {
        guard let controller = contentViewController as? ViewController else { return }
        
        isPresented = true
        makeKeyAndOrderFront(nil)
        controller.clearInputField()
        controller.focusAndSelectInputField()
        startOutsideClickMonitor()
    }
    
    /// Hides the panel and stops monitoring outside events.
    func hidePanel() {
        isPresented = false
        close()
        stopOutsideClickMonitor()
    }
    
    // MARK: - Event Monitoring
    
    private func startOutsideClickMonitor() {
        stopOutsideClickMonitor()
        
        outsideClickMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.leftMouseDown, .rightMouseDown]
        ) { [weak self] _ in
            guard let self = self, self.isPresented else { return }
            self.hidePanel()
        }
    }
    
    private func stopOutsideClickMonitor() {
        if let monitor = outsideClickMonitor {
            NSEvent.removeMonitor(monitor)
            outsideClickMonitor = nil
        }
    }
    
    // MARK: - Overrides
    
    override func close() {
        super.close()
        isPresented = false
        stopOutsideClickMonitor()
    }
    
    override func performDrag(with event: NSEvent) {
        super.performDrag(with: event)
        isDragging = true
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        if isDragging {
            if let controller = contentViewController as? ViewController {
                controller.focusAndSelectInputField()
            }
            isDragging = false
        }
    }
}
