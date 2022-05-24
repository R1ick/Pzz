//
//  LoginVC.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 24.03.2022.
//

import UIKit
import RealmSwift

final class LoginVC: BaseViewController {
    
    //MARK: @IBOutlet's
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let apiManager: Fetch = APIManager()
    private let storage = StorageService.shared
    private var users: Results<User>!
    private var user: User?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        changeNavStack()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users = realm.objects(User.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegistration" {
            guard let reg = segue.destination as? RegistrationVC else { return }
            reg.closure = { [weak self] user in
                self?.user = user
            }
        }
        if segue.identifier == "toMain" {
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: @IBAction's
extension LoginVC {
    @objc func loginTapped() {
        guard let phone = emailTextField.text,
              let pas = passwordTextField.text
        else { return }
        if users.count < 1 {
            showAlert(title: "Ошибка", message: "Вам необходимо зарегистрироваться!")
            return
        }
        apiManager.login(phone: phone, password: pas) { [weak self] profile, error in
            guard let self = self else { return }
            if let _ = error {
                self.showAlert(title: "Неверный номер телефона или пароль")
                print(#file, #line, error.debugDescription)
            }
            if let profile = profile {
                let main = MainWrapperViewController(nibName: nil, bundle: nil)
                for user in self.users {
                    if user.login == phone {
                        if user.userInfo == nil || user.userInfo?.orderSettings == nil {
                            guard let user = self.user else { return }
                            self.storage.createUserInfo(for: user)
                            KeychainHelper.username = phone
                        }
                        self.user = user
                        KeychainHelper.username = user.login
                        self.storage.updateUserInfo(for: user,
                                               with: [.name(profile.name ?? "Username"),
                                                      .phone(profile.phone ?? "+375")])
                        main.user = user
                    }
                }
                UserDefaults.standard.set(true, forKey: "isLogin")
                if let addresses = profile.addresses, let user = self.user  {
                    self.checkAddresses(for: user, with: addresses)
                }
                self.sceneDelegate.window?.rootViewController = main
                
            }
        }
    }
    
    @IBAction func registrationButtonTapped() {
        performSegue(withIdentifier: "toRegistration", sender: nil)
    }
}

//MARK: private functions
extension LoginVC {
    private func setupUI() {
        titleLabel.font = Global.mainFontWithSize(size: 48)
        titleLabel.textAlignment = .center
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.strokeWidth : -6.0
        ] as [NSAttributedString.Key : Any]
        titleLabel.attributedText = NSMutableAttributedString(string: "пицца\nлисицца", attributes: attributes)
        [emailTextField, passwordTextField].forEach {
            $0?.font = Global.mainFontWithSize(size: 16)
            $0?.backgroundColor = #colorLiteral(red: 0.9794260859, green: 0.939825058, blue: 0.9189633727, alpha: 1)
            $0?.textColor = #colorLiteral(red: 0.4286657572, green: 0.4436271787, blue: 0.5793042779, alpha: 1)
            $0?.layer.cornerRadius = 12
            $0?.clipsToBounds = true
        }
        loginButton.layer.cornerRadius = 12
        loginButton.backgroundColor = #colorLiteral(red: 1, green: 0.4133270383, blue: 0, alpha: 1)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    private func changeNavStack() {
        self.navigationController?.viewControllers = [self]
    }
    
    private func checkAddresses(for user: User, with addresses: [PzzAddress]) {
        var convertedAddresses = [Adress]()
        for address in addresses {
            let converted = self.convertePzzToRealmAddress(address)
            convertedAddresses.append(converted)
        }
        if let existingAddresses = user.userInfo?.addresses, existingAddresses.count > 0 {
            for address in convertedAddresses {
                if !existingAddresses.contains(address) {
                    self.storage.saveAdressFor(user, adress: address)
                }
            }
        } else {
            for (index, address) in convertedAddresses.enumerated() {
                storage.saveAdressFor(user, adress: address)
                if index == convertedAddresses.count - 1 {
                    storage.changeCurrentAdress(with: address, for: user)
                }
            }
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let frame = keyboardFrame.cgRectValue
        
        self.constraint.constant = -(frame.size.height) / 2
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.constraint.constant = 0.0
    }
}
