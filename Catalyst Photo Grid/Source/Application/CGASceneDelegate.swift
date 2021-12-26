//
//  CGASceneDelegate.swift
//  Catalyst Grid App
//
//  Created by Steven Troughton-Smith on 07/10/2021.
//  
//

import UIKit
import AppKit

class CGASceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	
#if targetEnvironment(macCatalyst)
	var displayModeToolbarItem:NSToolbarItem?
#endif
	
	func buildPrimaryUI() {
		
		guard let window = window, let windowScene = window.windowScene else { return }

		let mainVC = CGAMainViewController()
		mainVC.sceneDelegate = self
		
		window.rootViewController = mainVC
		
#if targetEnvironment(macCatalyst)
		
		mainVC.navigationController?.isNavigationBarHidden = true
		
		generateDynamicToolbarItems()

		let toolbar = NSToolbar(identifier: NSToolbar.Identifier("CGASceneDelegate.Toolbar"))
		toolbar.delegate = self
		toolbar.displayMode = .iconOnly
		toolbar.allowsUserCustomization = false
		
		
		windowScene.titlebar?.toolbar = toolbar
		windowScene.titlebar?.toolbarStyle = .unified
		windowScene.titlebar?.titleVisibility = .hidden
#endif
	}
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else {
			fatalError("Expected scene of type UIWindowScene but got an unexpected type")
		}
		window = UIWindow(windowScene: windowScene)
		
		if let window = window {
			
			buildPrimaryUI()
			window.makeKeyAndVisible()
		}
	}
}
