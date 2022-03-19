//
//  MatchHeaderViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 18.03.2022.
//

import UIKit
import Firebase
protocol IMatchHeaderViewController {
    func matchPerson(match: Matching)
}
class MatchHeaderViewController: ListController<MatchCell, Matching> {
    var delegate: IMatchHeaderViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        getMatches()
    }
    fileprivate func setLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let matchPerson = data[indexPath.item]
        delegate?.matchPerson(match: matchPerson)
    }
    fileprivate func getMatches() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection(FirebasePath.matchingMesage).document(userID).collection(FirebasePath.matching).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            var matching = [Matching]()
            snapshot?.documents.forEach({ (document) in
                let data = document.data()
                matching.append(.init(data: data))
            })
            self.data = matching
        }        
    }
}
extension MatchHeaderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 0, right: 15)
    }
}
