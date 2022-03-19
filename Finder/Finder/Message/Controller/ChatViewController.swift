//
//  ChatViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 13.03.2022.
//

import UIKit
import Firebase

class ChatViewController: ListController<MessageCell, Message> {

    fileprivate var matching: Matching
    var currentUser: User?
    private let topPadding: CGFloat = 160
    lazy var inputBarKeyboardView: InputBarKeyboardView = {
        return InputBarKeyboardView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
    }()
    override var inputAccessoryView: UIView? {
        get {
            return inputBarKeyboardView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }    
    init(matching: Matching) {
        self.matching = matching
        super.init()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var navigationBar = MessageNavBar(matching: matching)
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        setViews()
        getMessages()
    }
    fileprivate func getCurrentUser() {
        Firestore.firestore().getCurrentUser { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.currentUser = user
        }
    }
    fileprivate func getMessages() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let query = Firestore.firestore().collection(FirebasePath.matchingMesage).document(currentUserID)
            .collection(matching.profileID).order(by: "timestamp")
        query.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            snapshot?.documentChanges.forEach({ (documentChange) in
                if documentChange.type == .added {
                    let messageData = documentChange.document.data()
                    self.data.append(Message.init(data: messageData))
                }
            })
            self.collectionView.scrollToItem(at: [0, self.data.count - 1], at: .bottom, animated: true)
        }
    }
    @objc fileprivate func goToBack() {
        navigationController?.popViewController(animated: true)
    }
    @objc fileprivate func goToReport() {
        print("Direct to reporting")
    }
    @objc fileprivate func sendMessage() {
        saveCurrentMessage()
        saveLastMessage()
    }
    fileprivate func saveCurrentMessage() {
        print(inputBarKeyboardView.messageTextView.text ?? "")
        guard let currentMessage = inputBarKeyboardView.messageTextView.text else { return }
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let senderCollection = Firestore.firestore().collection(FirebasePath.matchingMesage).document(currentUserID).collection(matching.profileID)
        let createdData = ["message": currentMessage,
                           "senderID": currentUserID,
                           "receiverID": matching.profileID,
                           "timestamp": Timestamp(date: Date())] as [String: Any]
        senderCollection.addDocument(data: createdData) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.inputBarKeyboardView.messageTextView.text = nil
            self.inputBarKeyboardView.placeholderLabel.isHidden = false
            self.inputBarKeyboardView.sendButton.isEnabled = false
        }
        let receiverCollection = Firestore.firestore().collection(FirebasePath.matchingMesage).document(matching.profileID).collection(currentUserID)
        receiverCollection.addDocument(data: createdData) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    fileprivate func saveLastMessage() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        guard let currentMessage = inputBarKeyboardView.messageTextView.text else { return }
        let lastMessageSender = ["message": currentMessage,
                                 "username": matching.username,
                                 "userID": matching.profileID,
                                 "imageUrl": matching.profileImageUrl,
                                 "timestamp": Timestamp(date: Date())] as [String: Any]
       Firestore.firestore().collection(FirebasePath.matchingMesage).document(currentUserID)
            .collection(FirebasePath.lastMessages).document(matching.profileID).setData(lastMessageSender) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        guard let currentUser = currentUser else { return }
        let lastMessageReceiver = ["message": currentMessage,
                                   "username": currentUser.username ?? "",
                                   "userID": currentUser.userID ?? "",
                                   "imageUrl": currentUser.firstImageUrl ?? "",
                                   "timestamp": Timestamp(date: Date())] as [String: Any]
       Firestore.firestore().collection(FirebasePath.matchingMesage).document(matching.profileID)
            .collection(FirebasePath.lastMessages).document(currentUserID).setData(lastMessageReceiver) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
    }
    @objc private func setKeyboard() {
        collectionView.scrollToItem(at: [0,data.count - 1], at: .bottom, animated: true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension ChatViewController {
    fileprivate func setViews() {
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset.top = topPadding
        collectionView.verticalScrollIndicatorInsets.top = topPadding
        view.addSubview(navigationBar)
        configureLayout()
        configureTarget()
        setObserver()
    }
    fileprivate func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(setKeyboard), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    fileprivate func configureLayout() {
        navigationBar.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: topPadding))
    }
    fileprivate func configureTarget() {
        navigationBar.backButton.addTarget(self, action: #selector(goToBack), for: .touchUpInside)
        navigationBar.reportButton.addTarget(self, action: #selector(goToReport), for: .touchUpInside)
        inputBarKeyboardView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
}
extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let calculateCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        calculateCell.data = self.data[indexPath.item]
        calculateCell.layoutIfNeeded()
        let calculateSize = calculateCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        return .init(width: view.frame.width, height: calculateSize.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}
