//
//  CGAGridViewController.swift
//  Catalyst Grid App
//
//  Created by Steven Troughton-Smith on 07/10/2021.
//

import UIKit
import Foundation


class CGAGridViewController: UICollectionViewController {
	
	let reuseIdentifier = "Cell"
	let padding = UIFloat(4)
	
	enum DisplayMode:Int {
		case square
		case aspect
	}
	
	enum HIGridSection {
		case main
	}
	
	var displayMode = DisplayMode.square {
		didSet {
			NotificationCenter.default.post(name: .displayModeChanged, object: String(self.displayMode.rawValue))
		}
	}
	
	struct HIGridItem: Hashable {
		var title: String = ""
		var image: String = ""
		
		func hash(into hasher: inout Hasher) {
			hasher.combine(identifier)
		}
		static func == (lhs: HIGridItem, rhs: HIGridItem) -> Bool {
			return lhs.identifier == rhs.identifier
		}
		private let identifier = UUID()
	}
	
	var dataSource: UICollectionViewDiffableDataSource<HIGridSection, HIGridItem>! = nil
	
	init() {
		let layout = UICollectionViewFlowLayout()
		
		super.init(collectionViewLayout: layout)
		
		guard let collectionView = collectionView else { return }
		
		title = "Photos"
		
		collectionView.selectionFollowsFocus = true
		collectionView.allowsMultipleSelection = true
		
		collectionView.backgroundColor = .systemBackground
		collectionView.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		collectionView.register(CGAGridViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		
		configureDataSource()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Data Source -
	
	func configureDataSource() {
		
		dataSource = UICollectionViewDiffableDataSource<HIGridSection, HIGridItem>(collectionView: collectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, item: HIGridItem) -> UICollectionViewCell? in
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath)
			
			if let cell = cell as? CGAGridViewCell {
				/*
				 Customize cell here
				 */
				
				cell.imageView.image = UIImage(named:item.image)
				cell.displayMode = self.displayMode
			}
			
			return cell
		}
		
		collectionView.dataSource = dataSource
		
		refresh()
	}
	
	
	func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<HIGridItem> {
		var snapshot = NSDiffableDataSourceSectionSnapshot<HIGridItem>()
		
		var items:[HIGridItem] = []
		
		/* Just some dummy items to populate the grid */
		for i in 0 ..< 19 {
			
			var item = HIGridItem()
			item.image = "\(i)"
			items.append(item)
		}
		
		snapshot.append(items)
		
		return snapshot
	}
	
	func refresh() {
		guard let dataSource = collectionView.dataSource as? UICollectionViewDiffableDataSource<HIGridSection, HIGridItem> else { return }
		
		dataSource.apply(initialSnapshot(), to: .main, animatingDifferences: false)
	}
	
	// - MARK: Manual Layout Sizing (Fast)
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		var columns = 4
		let threshold = UIFloat(200)
		
		guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
		
		while view.bounds.size.width/CGFloat(columns) > threshold
		{
			columns += 1
		}
		
		let frame = view.bounds.inset(by: collectionView.contentInset)
		
		let itemSize = (frame.width - padding*CGFloat(columns-1)) / CGFloat(columns)
		
		layout.itemSize = CGSize(width: itemSize, height: itemSize)
		layout.minimumLineSpacing = padding
		layout.minimumInteritemSpacing = 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if let cell = cell as? CGAGridViewCell {
			cell.displayMode = self.displayMode
		}
	}
	
	// MARK: - Multiple Selection
	
	override func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
		return true
	}
    
    // MARK: - Support for Select All (Cmd + A)
    
    override func selectAll(_ sender: Any?) {
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                collectionView.selectItem(at: indexPath,
                                          animated: true,
                                          scrollPosition: [])
            }
        }
    }
	
	// MARK: - Aspect Ratio
	
	@objc func toggleAspect(_ sender:Any?) {
		if displayMode == .square {
			displayMode = .aspect
		}
		else {
			displayMode = .square
		}
		
		UIView.animate(withDuration:0.2) { [self] in
			collectionView.visibleCells.forEach({
				if let cell = $0 as? CGAGridViewCell {
					cell.displayMode = displayMode
				}
			})
		}
	}
	
	// MARK: -
	
	override var canBecomeFirstResponder:Bool {
		return true
	}
	
}
