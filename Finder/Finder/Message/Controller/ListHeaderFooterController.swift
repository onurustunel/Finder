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
        collectionView.backgroundColor = .white
        collectionView.register(T.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(H.self, forCellWithReuseIdentifier: UICollectionView.elementKindSectionHeader)
        collectionView.register(F.self, forCellWithReuseIdentifier: UICollectionView.elementKindSectionFooter)        
    }
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? T {
            cell.data = data[indexPath.row]
            cell.neededController = self
            return cell
        }
        return UICollectionViewCell()
    }
    open func setHeader() {
        
    }
    open func setFooter() {
        
    }
    open override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryID, for: indexPath)
        if let _ = supplementaryView as? H {
            setHeader()
        } else if let _ = supplementaryView as? F {
            setFooter()
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
