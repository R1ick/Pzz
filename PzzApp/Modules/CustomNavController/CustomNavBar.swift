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
    
    private let apiManager: Fetch = APIManager()
    
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
        setupDeliveryTime()
    }
    
    private func setupUI() {
        titleLabel.font = Global.mainFontWithSize(size: 34)
        titleLabel.text = "755-66-55"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
    }
    
    private func setupDeliveryTime() {
        apiManager.getDeliveryTime { [weak self] time, error in
            if let _ = error { return }
            if let time = time {
                self?.deliveryTimeLabel.text = time
                self?.setupUI()
            }
        }
    }
}
