//
//  BaseViewController.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 28.03.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
    }
    
    func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Oк", style: .default)
        let cancel = UIAlertAction(title: "Отменить", style: .destructive)
        alert.addActions([cancel, ok])
        
        present(alert, animated: true)
    }
    
    func convertePzzToRealmAddress(_ address: PzzAddress) -> Adress {
        let adr = Adress()
        adr.street = address.street?.title ?? ""
        adr.building = address.house?.title ?? ""
        adr.entrance = address.entrance ?? ""
        adr.stage = address.floor ?? ""
        adr.flat = address.flat ?? ""
        adr.buzzer = address.intercom ?? ""
        return adr
    }
}
