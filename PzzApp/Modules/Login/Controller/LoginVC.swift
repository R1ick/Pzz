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
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    private let storage = StorageService.shared
    private var users: Results<User>!
    private var user: User?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        changeNavStack()
        users = realm.objects(User.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    @IBAction func emailTFdidEditing() {
        guard let email = emailTextField.text else { return }
        emailErrorLabel.isHidden = VerificationService.isValidEmail(email: email) ? true : false
    }
    @IBAction func passwordTFdidEditing() {
        guard let password = passwordTextField.text else { return }
        passwordErrorLabel.text = "Weak password"
        passwordErrorLabel.isHidden = (VerificationService.isValidPassword(pass: password) == .weak) || (VerificationService.isValidPassword(pass: password) == .veryWeak) ? false : true
    }
    @objc func loginTapped() {
        guard let email = emailTextField.text,
              let pas = passwordTextField.text
        else { return }
        if !VerificationService.isValidEmail(email: email) {
            showAlert(title: "Error", message: "Invalid email")
            return
        }
        if VerificationService.isValidPassword(pass: pas) == .weak  || pas == ""{
            showAlert(title: "Error", message: "Invalid password")
            return
        }
        for user in users {
            if user.login == email, user.password == pas {
                // TODO: show main screen
                let main = MainWrapperViewController(nibName: nil, bundle: nil)
                main.user = user
                UserDefaults.standard.set(true, forKey: "isLogin")
                sceneDelegate.window?.rootViewController = main
                return
            }
        }
        showAlert(title: "Invalid login or password")
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
