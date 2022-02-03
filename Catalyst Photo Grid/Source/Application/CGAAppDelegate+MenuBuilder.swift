//
//  CGAAppDelegate+NSToolbar.swift
//  Catalyst Grid App
//
//  Created by Steven Troughton-Smith on 07/10/2021.
//  
//

import UIKit

extension CGAAppDelegate {
	
	override func buildMenu(with builder: UIMenuBuilder) {
		if builder.system == UIMenuSystem.context {
			return
		}
		
		super.buildMenu(with: builder)
		
		builder.remove(menu: .format)
		builder.remove(menu: .toolbar)
		builder.remove(menu: .newScene)
	}
}
