//
//  ListHeaderFooterController.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
open class ListHeaderFooterController <T: ListCell<U>, U, H: UICollectionReusableView, F: UICollectionReusableView>: UICollectionViewController {
    var data = [U]() {
        didSet {
            collectionView.reloadData()
        }
    }
    fileprivate let cellID = "cellID"
    fileprivate let supplementaryID = "supplementaryViewID"
    func setCellHeight(indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let cell = T()
        let maxHeight: CGFloat = 1000
        cell.frame = .init(x: 0, y: 0, width: cellWidth, height: maxHeight)
        cell.data = data[indexPath.row]
        cell.layoutIfNeeded()
        return cell.systemLayoutSizeFitting(.init(width: cellWidth, height: maxHeight)).height
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = ConstantColor.darkBackgroundColor
        collectionView.register(T.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(H.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: supplementaryID)
        collectionView.register(F.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: supplementaryID)
    }
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? T {
            cell.data = data[indexPath.row]
            cell.neededController = self
            return cell
        }
        return UICollectionViewCell()
    }
    open func setHeader(_ header: H) {
    
    }
    open func setFooter(_ footer: F) {
    
    }
    open override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryID, for: indexPath)
        if let header = supplementaryView as? H {
            setHeader(header)
        } else if let footer = supplementaryView as? F {
            setFooter(footer)
        }
        return supplementaryView
    }
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    open override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        view.layer.zPosition = -1
    }
    public init(scrollDirection: UICollectionView.ScrollDirection = .vertical) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        super.init(collectionViewLayout: layout)
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
