//
//  LaunchVC.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 24.03.2022.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftUI

class LaunchVC: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var animationTimer: Timer?
    private var segueTimer: Timer?
    
    private let images = [UIImage(named: "0"), UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4"), UIImage(named: "5"), UIImage(named: "6"), UIImage(named: "7")]
    private var index = 0
    
    private var products = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimers()
        print("url", realm.configuration.fileURL)
    }
    
    private func startTimers() {
        animationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: true)
        segueTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(showLogin), userInfo: nil, repeats: false)
    }
    
    @objc private func startAnimation() {
        if index < 7 {
            imageView.image = images[index]
            index += 1
        } else {
            index = 0
        }
    }
    
    @objc private func showLogin() {
        let loginStoryboard = UIStoryboard(name: "Login", bundle: .main)
        let login = loginStoryboard.instantiateViewController(withIdentifier: "login")
        
        if let isLogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool {
            if isLogin {
                let main = MainWrapperViewController(nibName: nil, bundle: nil)
                let users = realm.objects(User.self)
                for user in users {
                    if user.login == KeychainHelper.username {
                        main.user = user
                        sceneDelegate.window?.rootViewController = main
                        return
                    }
                }
                self.navigationController?.show(login, sender: nil)
            } else {
                self.navigationController?.show(login, sender: nil)
            }
        } else {
            self.navigationController?.show(login, sender: nil)
        }
        animationTimer?.invalidate()
        segueTimer?.invalidate()
    }
}
