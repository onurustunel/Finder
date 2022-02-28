//
//  AgeRangeTableViewCell.swift
//  Finder
//
//  Created by Onur Ustunel on 28.02.2022.
//

import UIKit

protocol IAgeRangeSlider {
    func minimumAgeSlider(slider: UISlider)
    func maximumAgeSlider(slider: UISlider)
}
class AgeRangeTableViewCell: UITableViewCell {
    
    static let identifier = "AgeRangeTableViewCell"
    var delegate: IAgeRangeSlider?
    var user: User? {
        didSet {
            updateCell()
        }
    }
    let minimumAgeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 90
        return slider
    }()
    let maximumAgeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 90
        return slider
    }()
    private lazy var minimumAge: AgeRangeLabel = {
        let label = AgeRangeLabel()
        label.font = AppFont.appFontStyle(size: 16, style: .bold)
        label.text = "Min 18"
        return label
    }()    
    private lazy var maximumAge: AgeRangeLabel = {
        let label = AgeRangeLabel()
        label.font = AppFont.appFontStyle(size: 16, style: .bold)
        label.text = "Max 18"
        return label
    }()
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureUI() {
        setView()
        selectionStyle = .none
    }
    private func setView() {
        let stackView = UIStackView(arrangedSubviews: [
                                        UIStackView(arrangedSubviews: [minimumAge, minimumAgeSlider]),
                                        UIStackView(arrangedSubviews: [maximumAge, maximumAgeSlider])])
        stackView.axis = .vertical
        stackView.spacing = 16
        contentView.addSubviews(stackView)
        stackView.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor,
                         trailing: contentView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        minimumAgeSlider.addTarget(self, action: #selector(minimumAgeChanged), for: .valueChanged)
        maximumAgeSlider.addTarget(self, action: #selector(maximumAgeChanged), for: .valueChanged)
    }
    @objc func minimumAgeChanged(slider: UISlider) {
        minimumAge.text = "Min \(Int(slider.value))"
        delegate?.minimumAgeSlider(slider: slider)
    }
    @objc func maximumAgeChanged(slider: UISlider) {
        maximumAge.text = "Max \(Int(slider.value))"
        delegate?.maximumAgeSlider(slider: slider)
    }
    func updateCell() {
        minimumAgeSlider.value = Float(user?.minimumAge ?? 18)
        minimumAge.text = "Min \(Int(minimumAgeSlider.value))"
        maximumAgeSlider.value = Float(user?.maximumAge ?? 90)
        maximumAge.text = "Min \(Int(maximumAgeSlider.value))"
    }
}
