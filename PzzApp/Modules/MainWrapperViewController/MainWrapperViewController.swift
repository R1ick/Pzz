//
//  MainWrapperViewController.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 27.03.2022.
//

import UIKit
import RealmSwift

final class MainWrapperViewController: BaseViewController {

    var user: User?
    
    private lazy var tab = CustomTabBarController(nibName: nil, bundle: nil)
    private let networkManager: Fetch = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
        requestProducts()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    private func setupTab() {
        tab.willMove(toParent: self)
        view.addSubview(tab.view)
        addChild(tab)
        tab.didMove(toParent: self)
    }
    
    private func requestProducts() {
        guard let main = tab.viewControllers?.first,
              let main = main as? ProductsVC
        else { return }
       
        let storage = StorageService.shared
        
        main.user = self.user
        storage.user = self.user
        Global.currentUser = self.user ?? User()
        
        print("#URL", Global.currentUser)
        
        Task {
            await networkManager.getProducts() { [unowned self] products, error in
                if let error = error { debugPrint(error) }
                if let products = products {
                    main.products = products
                    DispatchQueue.main.async {
                        main.tableView.reloadData()
                    }
                }
            }
        }
    }

   
}
