//
//  ProductCell.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 25.03.2022.
//

import UIKit
import RealmSwift

class ProductCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var bigDescriptionLabel: UILabel!
    @IBOutlet weak var bigPriceLabel: UILabel!
    @IBOutlet weak var anonceLabel: UILabel!
    @IBOutlet weak var mediumPriceLabel: UILabel!
    @IBOutlet weak var bigWeightLabel: UILabel!
    @IBOutlet weak var mediumWeightLabel: UILabel!
    @IBOutlet weak var bigBasketButton: UIButton!
    @IBOutlet weak var standartBasketButton: UIButton!
    @IBOutlet weak var mediumStack: UIStackView!
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    @IBAction func bigButtonTapped() {
        let bigFood = BasketElement()
        bigFood.name = productName.text ?? "###"
        bigFood.size = "Большая"
        bigFood.count = 1
        bigFood.onePrice = refactorPrice(string: bigPriceLabel.text ?? "1.0") ?? 1.0
        bigFood.price = refactorPrice(string: bigPriceLabel.text ?? "1.0") ?? 1.0
        StorageService.shared.save(bigFood)
        feedbackGenerator.impactOccurred()
    }
    @IBAction func standartButtonTapped() {
        let mediumFood = BasketElement()
        mediumFood.name = productName.text ?? "###"
        mediumFood.size = "Стандартная"
        mediumFood.count = 1
        mediumFood.onePrice = refactorPrice(string: mediumPriceLabel.text ?? "1.0") ?? 1.0
        mediumFood.price = refactorPrice(string: mediumPriceLabel.text ?? "1.0") ?? 1.0
        StorageService.shared.save(mediumFood)
        feedbackGenerator.impactOccurred()
    }
    
    func configureCell() {
        [bigBasketButton, standartBasketButton].forEach {
            $0?.layer.cornerRadius = 10
            $0?.setTitleColor(.green, for: .selected)
        }
    }
    
    private func refactorPrice(string: String) -> Double? {
        guard let index = string.firstIndex(of: ",") else { return nil }
        let str1 = string.substring(to: index)
        let str2 = string.substring(from: index).dropFirst()
        let newString = "\(str1).\(str2)"
        let newPrice = Double(newString)
        return newPrice!
    }
}


