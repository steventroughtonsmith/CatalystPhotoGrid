//
//  CGAGridViewCell.swift
//  Catalyst Grid App
//
//  Created by Steven Troughton-Smith on 07/10/2021.
//

import UIKit
import CoreGraphics

class CGAGridViewCell: UICollectionViewCell {
	
	/*
		Keyboard focus & cell selection are two different things, so conceptually it is
		important to remember that they may not necessarily be linked. In this example,
		we're using two different 'selection' styles to underscore that.
	 
		As of macOS 12.1, multi-select (drag-select) handles focus state incorrectly,
		so as soon as that behavior is improved this distinction may not be necessary.
	 */
	
	let focusRingView = UIView()
	let selectionRingView = UIView()
	
	let imageView = UIImageView()
	
	var displayMode:CGAGridViewController.DisplayMode = .square {
		didSet {
			layoutSubviews()
		}
	}
	
	@objc var showFocusRing:Bool = false {
		didSet {
			if showFocusRing {
				focusRingView.alpha = 1
			}
			else {
				focusRingView.alpha = 0
			}
		}
	}
	
	@objc var showSelectionRing:Bool = false {
		didSet {
			if showSelectionRing {
				selectionRingView.alpha = 1
			}
			else {
				selectionRingView.alpha = 0
			}
		}
	}
	
	override var isSelected: Bool {
		didSet {
			showSelectionRing = isSelected
		}
	}

	// MARK: -
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		imageView.layer.cornerCurve = .continuous
		imageView.layer.cornerRadius = UIFloat(8)
		imageView.layer.masksToBounds = true
		imageView.layer.borderWidth = UIFloat(0.5)
		imageView.layer.borderColor = UIColor.separator.cgColor
		
		imageView.contentMode = .scaleAspectFill
		
		contentView.addSubview(imageView)
		
		/* Selection Ring */
		
		selectionRingView.alpha = 0
		
		selectionRingView.layer.cornerRadius = UIFloat(8)
		selectionRingView.layer.borderWidth = UIFloat(4)
		selectionRingView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
		
		imageView.addSubview(selectionRingView)
		
		/* Focus Ring */
		
		focusRingView.alpha = 0
		
		focusRingView.layer.cornerRadius = UIFloat(8)
		focusRingView.layer.borderWidth = UIFloat(4)
		focusRingView.layer.borderColor = UIColor.systemBlue.cgColor
		
		imageView.addSubview(focusRingView)
		
		if #available(macCatalyst 15.0, iOS 15.0, *) {
			focusEffect = nil
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Layout -
	
	override func layoutSubviews() {
		super.layoutSubviews() // Always call super
		
		let contentBounds = contentView.bounds
		
		if displayMode == .square {
			imageView.layer.cornerRadius = 0
			focusRingView.layer.cornerRadius = 0
			selectionRingView.layer.cornerRadius = 0

			imageView.frame = contentBounds
			focusRingView.frame = imageView.bounds
			selectionRingView.frame = imageView.bounds
		}
		else {
			imageView.layer.cornerRadius = UIFloat(8)
			focusRingView.layer.cornerRadius = UIFloat(8)
			selectionRingView.layer.cornerRadius = UIFloat(8)

			/*
			 Here, the aspect ratio is hard-coded for this demo. But in a real app dealing with
			 photos you might have this ratio stored or calculated in your data model
			 */
			let insetBounds = contentBounds.insetBy(dx:UIFloat(8), dy:UIFloat(8))
			let aspectRatio = 3.0 / 4.0
			
			let desiredWidth = insetBounds.height * aspectRatio
			let desiredHeight = insetBounds.height
			
			imageView.frame = CGRect(x: (contentBounds.width-desiredWidth)/2, y: (contentBounds.height-desiredHeight)/2, width: desiredWidth, height: desiredHeight)
			focusRingView.frame = imageView.bounds
			selectionRingView.frame = imageView.bounds
		}
	}
	
	// MARK: Trait Changes -
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		
		/* CALayer color properties don't automatically update when Light/Dark mode changes */
		imageView.layer.borderColor = UIColor.separator.cgColor
		focusRingView.layer.borderColor = UIColor.systemBlue.cgColor
		selectionRingView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
	}
	
	// MARK: - Focus Support
	
	override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
		
		super.didUpdateFocus(in: context, with: coordinator)
		
		// customize the border of the cell instead of putting a focus ring on top of it.
		if context.nextFocusedItem === self {
			showFocusRing = true
		}
		else if context.previouslyFocusedItem === self {
			showFocusRing = false
		}
	}
}
