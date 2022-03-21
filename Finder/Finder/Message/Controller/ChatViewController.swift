//
//  ChatViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 13.03.2022.
//

import UIKit
import Firebase

class ChatViewController: UICollectionViewController {
    var data = [Message]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var uploadImage: UIImage? {
        didSet {
            sendImageMessage()
        }
    }
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
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate lazy var navigationBar = MessageNavBar(matching: matching)
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        getCurrentUser()
        setViews()
        getMessages()
    }
    private func setCollectionView() {
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.identifier)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.backgroundColor = ConstantColor.darkBackgroundColor
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
    @objc fileprivate func sendMessage(sender: UIButton) {
        let textMessage = sender.imageView?.image == UIImage(systemName: SendButtonConstant.text.rawValue)
        if textMessage {
            saveCurrentMessage()
            saveLastMessage()
        } else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    fileprivate func saveCurrentMessage() {
        guard let currentMessage = inputBarKeyboardView.messageTextView.text else { return }
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let senderCollection = Firestore.firestore().collection(FirebasePath.matchingMesage).document(currentUserID).collection(matching.profileID)
        let createdData = ["message": currentMessage,
                           "senderID": currentUserID,
                           "uploadImageUrl": "",
                           "messageType": MessageType.text.rawValue,
                           "receiverID": matching.profileID,
                           "timestamp": Timestamp(date: Date())] as [String: Any]
        senderCollection.addDocument(data: createdData) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.inputBarKeyboardView.messageTextView.text = nil
            self.inputBarKeyboardView.placeholderLabel.isHidden = false
            self.inputBarKeyboardView.sendButton.setImage(UIImage(systemName: SendButtonConstant.camera.rawValue), for: .normal)
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
                                 "uploadImageUrl": "",
                                 "messageType": MessageType.text.rawValue,
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
                                   "uploadImageUrl": "",
                                   "messageType": MessageType.text.rawValue,
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
    
    fileprivate func saveCurrentImageMessage() {
        firebaseImageSave { (url, error) in
            if let error = error {
                print("Image could not upload to server", error.localizedDescription)
                return
            }
            guard let url = url else { return }
            // image uploading time
            guard let currentUserID = Auth.auth().currentUser?.uid else { return }
            let senderCollection = Firestore.firestore().collection(FirebasePath.matchingMesage).document(currentUserID).collection(self.matching.profileID)
            let createdData = ["message": "",
                               "senderID": currentUserID,
                               "uploadImageUrl": url,
                               "messageType": MessageType.image.rawValue,
                               "receiverID": self.matching.profileID,
                               "timestamp": Timestamp(date: Date())] as [String: Any]
            senderCollection.addDocument(data: createdData) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.inputBarKeyboardView.messageTextView.text = nil
                self.inputBarKeyboardView.placeholderLabel.isHidden = false
                self.inputBarKeyboardView.sendButton.setImage(UIImage(systemName: SendButtonConstant.camera.rawValue), for: .normal)
            }
            let receiverCollection = Firestore.firestore().collection(FirebasePath.matchingMesage).document(self.matching.profileID).collection(currentUserID)
            receiverCollection.addDocument(data: createdData) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        
    }
    fileprivate func saveLastImageMessage() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let lastMessageSender = ["message": " 📷 ",
                                 "username": matching.username,
                                 "uploadImageUrl": "",
                                 "messageType": MessageType.text.rawValue,
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
        let lastMessageReceiver = ["message": "[Image]",
                                   "username": currentUser.username ?? "",
                                   "uploadImageUrl": "",
                                   "messageType": MessageType.text.rawValue,
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
    fileprivate func firebaseImageSave(completion: @escaping (String?, Error?) -> ()) {
        let imageName = UUID().uuidString
        let referance = Storage.storage().reference(withPath: "/Images/\(imageName)")
        let imageData = self.uploadImage?.jpegData(compressionQuality: 0.5) ?? Data()
        referance.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            referance.downloadURL { (url, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                let imageUrl = url?.absoluteString ?? ""
                completion(imageUrl, nil)
            }
        }
    }
    
    private func sendImageMessage() {
        saveCurrentImageMessage()
        saveLastImageMessage()
    }
    @objc private func setKeyboard() {
        collectionView.scrollToItem(at: [0, data.count - 1], at: .bottom, animated: true)
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
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentData = data[indexPath.row]
        if currentData.messageType == 2 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell {
                cell.data = currentData
                cell.delegate = self
                return cell
            }
        } else if currentData.messageType ==  1  {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.identifier, for: indexPath) as? MessageCell {
                cell.data = currentData
                return cell
            }
        }     
        return UICollectionViewCell()
    }
}
extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if data[indexPath.row].messageType == 1 {
            let calculateCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            calculateCell.data = self.data[indexPath.item]
            calculateCell.layoutIfNeeded()
            let calculateSize = calculateCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            return .init(width: view.frame.width, height: calculateSize.height)
        } else if data[indexPath.row].messageType == 2 {
            return .init(width: view.frame.width, height: 240)
        }
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            uploadImage = selectedImage
            dismiss(animated: true, completion: nil)
        }       
    }
}
extension ChatViewController: ImageCellTapped {
    func imageTapped(image: UIImage) {
        let imageViewController = ImagePreviewViewController(image: image)
        imageViewController.modalPresentationStyle = .overFullScreen
        present(imageViewController, animated: true, completion: nil)
    }
}
