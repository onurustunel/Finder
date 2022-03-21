//
//  MatchHeader.swift
//  Finder
//
//  Created by Onur Ustunel on 18.03.2022.
//

import UIKit
protocol IMatchHeader {
    func match(match: Matching)
}
class MatchHeader: UICollectionReusableView {
    let newMatchLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 0.8616023064, green: 0.3684691787, blue: 0.4407086372, alpha: 1))
    let horizontalViewController = MatchHeaderViewController()
    let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 0.8616023064, green: 0.3684691787, blue: 0.4407086372, alpha: 1))
    var delegate: IMatchHeader?
    override init(frame: CGRect) {
        super.init(frame: frame)
        createStackView(createStackView(newMatchLabel).padLeft(20),
                        horizontalViewController.view,
                        createStackView(messagesLabel).padLeft(20),
                        spacing: 20).withMarging(.init(top: 20, left: 0, bottom: 10, right: 0))
        horizontalViewController.delegate = self        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
extension MatchHeader: IMatchHeaderViewController {
    func matchPerson(match: Matching) {
        delegate?.match(match: match)
    }
}
