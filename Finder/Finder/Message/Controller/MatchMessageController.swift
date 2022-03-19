//
//  MatchMessageController.swift
//  Finder
//
//  Created by Onur Ustunel on 12.03.2022.
//

import UIKit
import Firebase

class MatchMessageController: ListHeaderController<ConversationCell, LastConversation, MatchHeader> {
    let customNavBar = MatchNavigationBar()
    var lastMessageDictionary = [String: LastConversation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getLastMessages()
        setView()        
    }
    fileprivate func getLastMessages() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection(FirebasePath.matchingMesage).document(currentUser).collection(FirebasePath.lastMessages).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            snapshot?.documentChanges.forEach({ (document) in
                if document.type == .added || document.type == .modified {
                    let addedlastMessage = document.document.data()
                    let lastMessage = LastConversation(data: addedlastMessage)
                    self.lastMessageDictionary[lastMessage.userID] = lastMessage
                }
                if document.type == .removed {
                    let messageData = document.document.data()
                    let deletingMessage = LastConversation(data: messageData)
                    self.lastMessageDictionary.removeValue(forKey: deletingMessage.userID)
                }
            })
            self.clearData()
        }
    }
    fileprivate func clearData() {
        let lastMessagesArray = Array(lastMessageDictionary.values)
        data = lastMessagesArray.sorted(by: { (first, second) -> Bool in
            return first.timestamp.compare(second.timestamp) == .orderedDescending
        })
    }
    override func setHeader(_ header: MatchHeader) {
        header.delegate = self
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lastMessage = data[indexPath.row]
        let matchData = ["userID": lastMessage.userID,
                         "nameSurname": lastMessage.username,
                         "imageUrl": lastMessage.imageUrl]
        let match = Matching(data: matchData)
        let viewController = ChatViewController(matching: match)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
extension MatchMessageController: IMatchHeader {
    func match(match: Matching) {
        let viewController = ChatViewController(matching: match)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
extension MatchMessageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 260)
    }
}
extension MatchMessageController {
    fileprivate func setView() {
        navigationController?.navigationBar.isHidden = true
        collectionView.backgroundColor = ConstantColor.darkBackgroundColor
        view.addSubview(customNavBar)
        collectionView.contentInset.top = 110
        collectionView.verticalScrollIndicatorInsets.top = 110
        configureLayout()
    }
    fileprivate func configureLayout() {
        customNavBar.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,
                            size: .init(width: 0, height: 160))
    }
}
