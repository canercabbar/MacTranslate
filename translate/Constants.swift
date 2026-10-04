//
//  Constants.swift
//  translate
//

import Foundation

/// Application-wide configuration and default settings.
enum Constants {
    /// Initial dimensions of the floating translation panel in points.
    enum Window {
        static let defaultWidth: CGFloat = 550
        static let defaultHeight: CGFloat = 360
        static let cornerRadius: CGFloat = 16.0
    }
    
    /// Default language settings for translation.
    enum Translation {
        /// Source language code (e.g. "auto" or "en").
        static let sourceLanguage = "en"
        /// Target language code (e.g. "tr").
        static let targetLanguage = "tr"
        
        /// Generates the Google Translate web URL based on configured languages.
        static var translateURL: URL {
            guard let url = URL(string: "https://translate.google.com/?sl=\(sourceLanguage)&tl=\(targetLanguage)") else {
                fatalError("Invalid Google Translate URL")
            }
            return url
        }
    }
}
