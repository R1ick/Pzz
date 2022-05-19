//
//  BasketIcon.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 23.04.2022.
//

import UIKit

class BasketIcon: UIView {
    @IBOutlet weak var countLabel: UILabel! {
        didSet {
            countLabel.layer.cornerRadius = countLabel.bounds.height / 2
            countLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var picture: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadView() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: nil).first as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
}
