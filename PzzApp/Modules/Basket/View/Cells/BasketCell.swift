//
//  BasketCell.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 31.03.2022.
//

import UIKit
import RealmSwift

final class BasketCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var food: BasketElement?
    
    var count: Int = 0 {
        willSet {
            try! realm.write {
                guard let food = food else { return }
                food.count = newValue
                food.price = food.onePrice * Double(food.count)
                if newValue == 0 {
                    realm.delete(food)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure()
    }
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        count -= 1
        feedbackGenerator.impactOccurred()
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        count += 1
        feedbackGenerator.impactOccurred()
    }
    
    func configure() {
        [minusButton, plusButton].forEach { $0?.layer.cornerRadius = ($0?.frame.width ?? 24) / 2 }
    }
    
  
}
