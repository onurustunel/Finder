//
//  MatchMessageController.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
import Firebase

class MatchMessageController: ListController<MatchCell, Matching> {
    let customNavBar = MatchNavigationBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        getMatches()
        navigationController?.navigationBar.isHidden = true
        collectionView.backgroundColor = ConstantColor.darkBackgroundColor
        setView()
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
extension MatchMessageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 150, height: 150)
    }
}
extension MatchMessageController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ChatViewController(matching: data[indexPath.item])
        navigationController?.pushViewController(viewController, animated: true)
    }
}
extension MatchMessageController {
    fileprivate func setView() {
        view.addSubview(customNavBar)
        collectionView.contentInset.top = 170
        configureLayout()
    }
    fileprivate func configureLayout() {
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 160))
    }
}
