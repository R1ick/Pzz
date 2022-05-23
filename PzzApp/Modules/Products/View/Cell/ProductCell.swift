//
//  ProductCell.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 25.03.2022.
//

import UIKit
import RealmSwift

final class ProductCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var bigPriceLabel: UILabel!
    @IBOutlet weak var anonceLabel: UILabel!
    @IBOutlet weak var mediumPriceLabel: UILabel!
    @IBOutlet weak var bigWeightLabel: UILabel!
    @IBOutlet weak var mediumWeightLabel: UILabel!
    @IBOutlet weak var bigBasketButton: UIButton!
    @IBOutlet weak var standartBasketButton: UIButton!
    @IBOutlet weak var mediumStack: UIStackView!
    
    var product: Product?
    var productType: ProductType = .pizza
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let apiManager: Fetch = APIManager()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productName.text = ""
        bigPriceLabel.text = ""
        bigWeightLabel.text = ""
        anonceLabel.text = ""
        mediumStack.isHidden = false
        mediumPriceLabel.text = ""
        mediumWeightLabel.text = ""
    }
    
    @IBAction func bigButtonTapped() {
        let bigFood = BasketElement()
        bigFood.name = productName.text ?? "###"
        bigFood.size = "Большая"
        bigFood.count = 1
        bigFood.onePrice = refactorPrice(string: bigPriceLabel.text)
        bigFood.price = refactorPrice(string: bigPriceLabel.text)
        StorageService.shared.save(bigFood)
        feedbackGenerator.impactOccurred()
    }
    @IBAction func standartButtonTapped() {
        let mediumFood = BasketElement()
        mediumFood.name = productName.text ?? "###"
        mediumFood.size = "Стандартная"
        mediumFood.count = 1
        mediumFood.onePrice = refactorPrice(string: mediumPriceLabel.text)
        mediumFood.price = refactorPrice(string: mediumPriceLabel.text)
        StorageService.shared.save(mediumFood)
        feedbackGenerator.impactOccurred()
    }
    
    func setupUI() {
        [bigBasketButton, standartBasketButton].forEach {
            $0?.layer.cornerRadius = 10
            $0?.setTitleColor(.green, for: .selected)
        }
    }
    
    func configure() {
        guard let product = product, let url = product.photoSmall else { return }
        apiManager.requestFoodImage(url: url, cell: self)
        anonceLabel.text = product.anonce
        bigWeightLabel.text = product.bigWeight
        mediumWeightLabel.text = product.mediumWeight
        let cf = 10_000.0
        switch productType {
        case .pizza, .snacks:
            productName.text = product.title
            mediumStack.isHidden = false
            if let big = product.bigPrice {
                let price = big / cf
                bigPriceLabel.text = String(format: "%.2f", price)
            }
        default:
            productName.text = product.title
            if let big = product.price {
                let price = Double(big) / cf
                bigPriceLabel.text = String(format: "%.2f", price)
            }
            mediumStack.isHidden = true
        }
        if let medium = product.mediumPrice {
            let price = medium / cf
            if price < 1 {
                mediumStack.isHidden = true
            } else {
                mediumPriceLabel.text = String(format: "%.2f", price)
            }
        } else {
            mediumStack.isHidden = true
        }
    }
    
    private func refactorPrice(string: String?) -> Double {
        guard let string = string, let price = Double(string) else { return  0.0 }
        return price
    }
}
