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

final class ProductsVC: BaseViewController {

    //MARK: @IBOutlet's
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customNavBar: CustomNavBar!

    var products = [[Product]]()
    var user: User?
    
    private let sections: [ProductType] = [.pizza, .snacks, .deserts, .drinks, .sauces]
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.clear
        registerCell(tableView)
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
        cell.setupUI()
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
        cell.product = product
        cell.productType = type
        cell.configure() 
    }
}
