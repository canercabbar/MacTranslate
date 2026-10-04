//
//  ViewController.swift
//  translate
//

import Cocoa
import WebKit

/// Main view controller managing the Google Translate WKWebView instance and JavaScript integrations.
final class ViewController: NSViewController {
    
    // MARK: - Properties
    
    /// Indicates whether the web page has completed its initial load and is ready for scripting.
    private(set) var isReady = false
    
    /// The dedicated web view rendering Google Translate.
    private var webView: WKWebView!
    
    /// Script handler message name for JavaScript to Swift communication.
    private static let scriptHandlerName = "callbackHandler"
    
    /// CSS injection to hide Google Translate's headers, footers, promo banners, and scrollbars.
    private var hideUIStyles: String {
        return """
        (function() {
            var style = document.createElement('style');
            style.id = 'gt-hide';
            style.textContent = `
                header,
                [jsname="JnGB8"],
                [jsname="gFMmu"],
                [jsname="tbSMse"],
                [jsname="lZZ7be"],
                [jsname="la0nce"],
                .feedback-link,
                a[href*="translate/problem"],
                #kvLWu, .VjFXz, .VlPnLc, .ebT7ne,
                .gp-footer, .hgbeOc.EjH7wc,
                [aria-haspopup] {
                    display: none !important;
                }
                html { overflow: hidden; }
                body::-webkit-scrollbar { display: none; }
            `;
            document.documentElement.appendChild(style);
        })();
        """
    }
    
    /// JavaScript keyboard listeners for in-panel navigation and translation actions.
    private var inPageShortcutsScript: String {
        return """
        document.addEventListener('keydown', function(event) {
            const keyCode = event.keyCode;
            const metaKey = event.metaKey;
            
            // ⌘ + A: Focus and select all text in input textarea
            if (metaKey && keyCode === 65) {
                event.preventDefault();
                const textarea = document.getElementsByTagName("textarea")[0];
                if (textarea) {
                    textarea.focus();
                    textarea.select();
                }
            }

            // Tab: Dismiss focus and return control to the previous active application
            if (keyCode === 9) {
                event.preventDefault();
                window.webkit.messageHandlers.\(ViewController.scriptHandlerName).postMessage(keyCode);
            }
            
            // ⌘ + L: Trigger text-to-speech (Listen) for source text
            if (metaKey && keyCode === 76) {
                const listenButton = document.querySelector(".m0Qfkd .VfPpkd-Bz112c-kBDsod:not(.VfPpkd-Bz112c-kBDsod-OWXEXe-IT5dJd)");
                if (listenButton) {
                    listenButton.click();
                }
                setTimeout(function() {
                    const textarea = document.getElementsByTagName("textarea")[0];
                    if (textarea) {
                        textarea.focus();
                        textarea.select();
                    }
                }, 800);
            }
            
            // ⌘ + S: Swap source and target languages
            if (metaKey && keyCode === 83) {
                const swapButton = Array.from(document.querySelectorAll("i")).find(i => i.innerText === "swap_horiz");
                if (swapButton) {
                    swapButton.click();
                }
            }
            
            // ⌘ + Enter: Accept typo fix / spelling suggestion if available
            if (metaKey && keyCode === 13) {
                const suggestionLabel = document.querySelector(".mvqA2c");
                if (suggestionLabel) {
                    suggestionLabel.click();
                }
            }
        });
        """
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: Self.scriptHandlerName)
        
        let hideScript = WKUserScript(
            source: hideUIStyles,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
        configuration.userContentController.addUserScript(hideScript)
        
        let initialFrame = NSRect(
            x: 0,
            y: 0,
            width: Constants.Window.defaultWidth,
            height: Constants.Window.defaultHeight
        )
        webView = WebView(frame: initialFrame, configuration: configuration)
        webView.navigationDelegate = self
        webView.setValue(false, forKey: "drawsBackground")
        
        webView.load(URLRequest(url: Constants.Translation.translateURL))
        
        self.view = webView
    }
    
    // MARK: - Public Actions
    
    /// Focuses and selects all text in the Google Translate source text area.
    func focusAndSelectInputField() {
        guard isReady else { return }
        
        let script = """
        setTimeout(function() {
            var textarea = document.getElementsByTagName("textarea")[0];
            if (textarea) {
                textarea.focus();
                textarea.select();
            }
        }, 20);
        """
        webView.evaluateJavaScript(script)
    }

    /// Clears the Google Translate source text area and triggers react/synthetic input events.
    func clearInputField() {
        guard isReady else { return }
        
        let script = """
        (function() {
            var textarea = document.getElementsByTagName("textarea")[0];
            if (textarea) {
                var nativeInputValueSetter = Object.getOwnPropertyDescriptor(window.HTMLTextAreaElement.prototype, 'value').set;
                nativeInputValueSetter.call(textarea, '');
                textarea.dispatchEvent(new Event('input', { bubbles: true }));
            }
        })();
        """
        webView.evaluateJavaScript(script)
    }
}

// MARK: - WKNavigationDelegate

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(inPageShortcutsScript)
        isReady = true
    }
}

// MARK: - WKScriptMessageHandler

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let keyCode = message.body as? Int else { return }
        
        // Tab key code (9) pressed in Google Translate text area
        if keyCode == 9 {
            if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                appDelegate.panel.resignKey()
            }
        }
    }
}
