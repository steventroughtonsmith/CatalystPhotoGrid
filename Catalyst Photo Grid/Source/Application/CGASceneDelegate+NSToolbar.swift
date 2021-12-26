//
//  CGASceneDelegate+NSToolbar.swift
//  Catalyst Grid App
//
//  Created by Steven Troughton-Smith on 07/10/2021.
//  
//

import UIKit

#if targetEnvironment(macCatalyst)
import AppKit

extension NSToolbarItem.Identifier {
	static let switchAspect = NSToolbarItem.Identifier("com.example.switchAspect")
}

extension NSNotification.Name {
	static let displayModeChanged = NSNotification.Name("DisplayModeChanged")
}

extension CGASceneDelegate: NSToolbarDelegate {
	
	func generateDynamicToolbarItems() {
		
		let barItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.arrowtriangle.2.inward"), style: .plain, target: nil, action: NSSelectorFromString("toggleAspect:"))
		/*
		 NSToolbarItemGroup does not auto-enable/disable buttons based on the responder chain, so we need an NSToolbarItem here instead
		 */
		
		let item = NSToolbarItem(itemIdentifier: .switchAspect, barButtonItem: barItem)
		
		item.label = NSLocalizedString("SWITCH_ASPECT", comment: "")
		item.toolTip = NSLocalizedString("SWITCH_ASPECT", comment: "")
		item.isBordered = true
		item.isNavigational = true
				
		displayModeToolbarItem = item
		
		watchForDisplayModeChanges()
	}
    
	func toolbarItems() -> [NSToolbarItem.Identifier] {
		return [.switchAspect]
	}
	
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItems()
	}
	
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarItems()
	}
	
	func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		if itemIdentifier == .switchAspect {
		
			return displayModeToolbarItem
		}
		
		return NSToolbarItem(itemIdentifier: itemIdentifier)
	}
	
	func watchForDisplayModeChanges() {
		NotificationCenter.default.addObserver(forName: .displayModeChanged, object: nil, queue: nil) { notification in
			
			guard let displayModeToolbarItem = self.displayModeToolbarItem else { return }
			
			if let displayMode = notification.object as? String {
				if displayMode == "0" {
					displayModeToolbarItem.image = UIImage(systemName:"rectangle.arrowtriangle.2.inward")
				}
				else {
					displayModeToolbarItem.image = UIImage(systemName:"rectangle.arrowtriangle.2.outward")
				}
			}
			
		}
	}
}
#endif
