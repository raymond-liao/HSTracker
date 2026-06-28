//
//  NSButton.swift
//  HSTracker
//
//  Created by Francisco Moraes on 12/11/22.
//  Copyright © 2022 Benjamin Michotte. All rights reserved.
//

import Cocoa

extension NSButton {
    func underlined() {
        let text = stringValue
        
        let attrString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single])
        attributedStringValue = attrString
    }

    func localizeTitle() {
        let localized = String.localizedString(title, comment: "")
        guard localized != title else {
            return
        }

        let attributes: [NSAttributedString.Key: Any]? = attributedTitle.length > 0 ? attributedTitle.attributes(at: 0, effectiveRange: nil) : nil
        title = localized
        if let attributes = attributes {
            attributedTitle = NSAttributedString(string: localized, attributes: attributes)
        }
    }
}

extension NSView {
    func localizeStaticText() {
        if let textField = self as? NSTextField, !textField.stringValue.isEmpty {
            textField.stringValue = String.localizedString(textField.stringValue, comment: "")
        }
        if let button = self as? NSButton {
            button.localizeTitle()
        }
        if let tooltip = toolTip, !tooltip.isEmpty {
            toolTip = String.localizedString(tooltip, comment: "")
        }

        subviews.forEach { $0.localizeStaticText() }
    }
}
