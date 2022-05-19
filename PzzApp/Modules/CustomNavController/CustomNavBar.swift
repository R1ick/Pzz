//
//  CustomNavBar.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 25.03.2022.
//

import UIKit

@IBDesignable final class CustomNavBar: UINavigationBar {

    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: CustomNavBar.self)
        bundle.loadNibNamed("CustomNavBar", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupUI() {
        titleLabel.font = Global.mainFontWithSize(size: 48)
        titleLabel.text = "пицца\nлисицца"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.strokeWidth : -6.0
        ] as [NSAttributedString.Key : Any]
        titleLabel.attributedText = NSMutableAttributedString(string: "пицца\nлисицца", attributes: attributes)
    }
}
