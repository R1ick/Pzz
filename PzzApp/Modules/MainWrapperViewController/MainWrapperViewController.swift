//
//  MainWrapperViewController.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 27.03.2022.
//

import UIKit
import RealmSwift

class MainWrapperViewController: BaseViewController {

    var user: User?
    
    private lazy var tab = CustomTabBarController(nibName: nil, bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
//        #if DEBUG
//        user = realm.objects(User.self).first
//        Global.currentUser = self.user!
//        #endif
        
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
        let networkManager: Fetch = APIManager.shared
       
        let storage = StorageService.shared
        if user?.userInfo == nil || user?.userInfo?.orderSettings == nil {
            storage.createUserInfo(for: self.user!)
        }
        
        main.user = self.user
        storage.user = self.user
        Global.currentUser = self.user ?? User()
        
        print("#URL", Global.currentUser)
        
        networkManager.fetchData() { products in
            main.products = products
            main.tableView.reloadData()
        }
    }

   
}
