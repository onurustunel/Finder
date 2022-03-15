//
//  ChatViewController.swift
//  Finder
//
//  Created by Onur Ustunel on 13.03.2022.
//

import UIKit
struct Message {
    let text: String
}
class MessageCell: ListCell<Message> {
    override var data: Message! {
        didSet {
            backgroundColor = .blue
        }
    }
}
class ChatViewController: ListController<MessageCell, Message> {
    fileprivate var matching: Matching
    
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
        setViews()
        data = [.init(text: "Hello"),
                .init(text: "How are you?"),
                .init(text: "I am very good.")]
        
    } 
    
    @objc fileprivate func goToBack() {
        navigationController?.popViewController(animated: true)
    }
    @objc fileprivate func goToReport() {
        print("report")
    }
}
extension ChatViewController {
    fileprivate func setViews() {
        collectionView.contentInset.top = 160
        view.addSubview(navigationBar)
        configureLayout()
        configureTarget()
    }
    fileprivate func configureLayout() {
        navigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 160))
    }
    fileprivate func configureTarget() {
        navigationBar.backButton.addTarget(self, action: #selector(goToBack), for: .touchUpInside)
        navigationBar.reportButton.addTarget(self, action: #selector(goToReport), for: .touchUpInside)
    }
}
extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}
