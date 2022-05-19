//
//  ProductsVC.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 25.03.2022.
//

import Alamofire
import AlamofireImage
import SwiftyJSON
import SwiftUI

protocol ProductsVCDelegate {
    func fetchProducts()
}

class ProductsVC: BaseViewController {

    //MARK: @IBOutlet's
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customNavBar: CustomNavBar!
        
    var products = [[JSON]]()
    var user: User?
    
    private let sections: [ProductType] = [.pizza, .snacks, .deserts, .drinks, .sauces]
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.clear
        registerCell(tableView)
        print(products)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.viewControllers = [self]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showOnboarding()
    }
    
}

//MARK: UITableViewDataSource
extension ProductsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let name = sections[section].rawValue.uppercased()
        
        return name
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = Global.mainFontWithSize(size: 16)
        header.textLabel?.frame(forAlignmentRect: view.frame)
        header.textLabel?.textColor = .lightGray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = sections[section]
        return products[type].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProductCell
        let type = sections[indexPath.section]
        cell.configureCell()
        configure(cell: cell, for: type, indexPath: indexPath)
        
        return cell
    }
    
    
}

//MARK: UITableViewDelegate
extension ProductsVC: UITableViewDelegate {
    
}

//MARK: UICollectionViewDataSource
extension ProductsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colCell", for: indexPath) as! SectionCell
        cell.sectionNameLabel.text = sections[indexPath.row].rawValue
        
        return cell
    }
    
    
}

//MARK: UICollectionViewDelegate
extension ProductsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let index = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: index, at: .top, animated: true)
        case 1:
            let index = IndexPath(row: 0, section: 1)
            tableView.scrollToRow(at: index, at: .top, animated: true)
        case 2:
            let index = IndexPath(row: 0, section: 2)
            tableView.scrollToRow(at: index, at: .top, animated: true)
        case 3:
            let index = IndexPath(row: 0, section: 3)
            tableView.scrollToRow(at: index, at: .top, animated: true)
        case 4:
            let index = IndexPath(row: 0, section: 4)
            tableView.scrollToRow(at: index, at: .top, animated: true)
        default: break
        }
    }
}

//MARK: Private functions
extension ProductsVC {
    private func registerCell(_ tableView: UITableView) {
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    private func showOnboarding() {
        let isNeed = UserDefaults.standard.bool(forKey: "needShowOnboarding")
        if !isNeed {
            let onboarding = UIHostingController(rootView: Onboarding())
            self.present(onboarding, animated: true)
        }
    }
    
    private func configure(cell: ProductCell, for type: ProductType, indexPath: IndexPath) {
        let product = products[type][indexPath.row]
        cell.productName.text = product["title"].string
        cell.anonceLabel.text = product["anonce"].string
        requestFoodImage(for: product, cell: cell)
        switch product {
        case _ where (indexPath.row < products[.pizza].count && product == products[.pizza][indexPath.row]) || (indexPath.row < products[.snacks].count && product == products[.snacks][indexPath.row]):
            cell.bigWeightLabel.text = product["big_weight"].string == nil ? product["big_amount"].string : product["big_weight"].string
            cell.mediumWeightLabel.text = product["medium_weight"].string
            let bigPrice = String(String(product["big_price"].intValue).dropLast())
            let bigPriceEnding = "\(bigPrice.last!)0"
            cell.bigPriceLabel.text = "\(bigPrice.dropLast()),\(bigPriceEnding)"
            if let mediumPriceInt = product["medium_price"].int, mediumPriceInt > 2 {
                let mediumPrice = String(String(mediumPriceInt).dropLast())
                let mediumPriceEnding = "\(mediumPrice.last!)0"
                cell.mediumStack.isHidden = false
                cell.mediumPriceLabel.text = "\(mediumPrice.dropLast()),\(mediumPriceEnding)"
            } else {
                cell.mediumStack.isHidden = true
            }
        case _ where (indexPath.row < 4 && product == products[.deserts][indexPath.row]) || (indexPath.row < products[.drinks].count && product == products[.drinks][indexPath.row]):
            cell.bigDescriptionLabel.isHidden = true
            cell.bigWeightLabel.isHidden = true
            if product["amount"].string == "1 порция" {
                cell.bigDescriptionLabel.isHidden = false
                cell.bigDescriptionLabel.text = product["amount"].string
            }
            let bigPrice = String(String(product["price"].intValue).dropLast())
            let bigPriceEnding = "\(bigPrice.last!)0"
            cell.productName.text = product == products[.drinks][indexPath.row] ? product["title_inner"].string : product["title"].string
            cell.bigPriceLabel.text = "\(bigPrice.dropLast()),\(bigPriceEnding)"
            cell.mediumStack.isHidden = true
        case _ where (indexPath.row < products[.sauces].count && product == products[.sauces][indexPath.row]):
            cell.bigDescriptionLabel.isHidden = true
            let bigPrice = String(String(product["price"].intValue).dropLast())
            let bigPriceEnding = "\(bigPrice.last!)0"
            cell.productName.text = product["title"].string
            cell.bigPriceLabel.text = "0\(bigPrice.dropLast()),\(bigPriceEnding)"
            cell.mediumStack.isHidden = true
        default: break
        }
    }
    
    private func requestFoodImage(for food: JSON, cell: ProductCell) {
        AF.request(food["photo_small"].url!).responseImage { response in
            switch response.result {
            case .success(let data):
                cell.productImageView.image = data
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension Array where Element == [JSON] {
    subscript (productType: ProductType) -> [JSON] {
        get {
            var products = [JSON]()
            for _ in self {
                switch productType {
                case .pizza:
                    products = self[0]
                case .snacks:
                    products = self[1]
                case .drinks:
                    products = self[3]
                case .deserts:
                    products = self[2]
                case .sauces:
                    products = self[4]
                }
            }
            return products
        }
    }
}
