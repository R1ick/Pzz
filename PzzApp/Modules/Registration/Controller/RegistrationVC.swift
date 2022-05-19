//
//  RegistrationVC.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 24.03.2022.
//

import UIKit
import RealmSwift

final class RegistrationVC: BaseViewController {

    //MARK: @IBOutlet's
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    var users: Results<User>!
    var closure: ((User) -> ())?
    
    private let storage = StorageService.shared
    
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        users = realm.objects(User.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}


//MARK: @IBAction's
extension RegistrationVC {
    @IBAction func emailTFdidEditing(_ sender: UITextField) {
        guard let email = emailTextField.text else { return }
        emailErrorLabel.isHidden = VerificationService.isValidEmail(email: email) ? true : false
    }
    @IBAction func passwordTFdidEditing(_ sender: UITextField) {
        guard let password = passwordTextField.text else { return }
        passwordErrorLabel.text = "Weak password"
        passwordErrorLabel.isHidden = (VerificationService.isValidPassword(pass: password) == .weak) || (VerificationService.isValidPassword(pass: password) == .veryWeak) ? false : true
        if let repPas = repeatPasTextField.text {
            passwordErrorLabel.text = "Passwords don't match"
            passwordErrorLabel.isHidden = VerificationService.isPassMatch(pass1: password, pass2: repPas) ? true : false
        }
    }
    @IBAction func repeatPasTFdidEditing(_ sender: UITextField) {
        guard let password = passwordTextField.text,
              let repPas = repeatPasTextField.text
        else { return }
        passwordErrorLabel.text = "Passwords don't match"
        passwordErrorLabel.isHidden = VerificationService.isPassMatch(pass1: password, pass2: repPas) ? true : false
    }
    @IBAction func registrationButtonTapped() {
        guard let email = emailTextField.text,
              let pas = passwordTextField.text,
              let repPas = repeatPasTextField.text
        else { return }
        if !VerificationService.isValidEmail(email: email) {
            showAlert(title: "Error", message: "Invalid email")
            return
        }
        if !VerificationService.isPassMatch(pass1: pas, pass2: repPas) || VerificationService.isValidPassword(pass: pas) ==  .weak {
            showAlert(title: "Error", message: "Invalid password")
            return
        }
        //TODO: write data with firebase and realm
        KeychainHelper.password = pas
        let user = User()
        user.login = email
        user.password = KeychainHelper.password ?? ""
        if !isUserExist(candidat: user) {
            storage.save(user)
            closure?(user)
            navigationController?.popToRootViewController(animated: true)
        } else { return }
    }
    
}

//MARK: Private functions
extension RegistrationVC {
    private func setupBackground() {
        backgroundImageView.image = UIImage(named: "headerBg")
        backgroundImageView.transform = backgroundImageView.transform.rotated(by: .pi / 2)
        backgroundImageView.transform = backgroundImageView.transform.scaledBy(x: 2.5, y: 7.5)
        backgroundImageView.contentMode = .scaleAspectFit
    }
    
    private func setupUI() {
        setupBackground()
        titleLabel.font = Global.mainFontWithSize(size: 48)
        titleLabel.text = "пицца\nлисицца"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.strokeWidth : -6.0
        ] as [NSAttributedString.Key : Any]
        titleLabel.attributedText = NSMutableAttributedString(string: "пицца\nлисицца", attributes: attributes)
        [emailTextField, passwordTextField, repeatPasTextField].forEach {
            $0?.layer.cornerRadius = 12
            $0?.backgroundColor = #colorLiteral(red: 0.9794260859, green: 0.939825058, blue: 0.9189633727, alpha: 1)
            $0?.clipsToBounds = true
            $0?.font = Global.mainFontWithSize(size: 16)
        }
        registrationButton.backgroundColor = .white.withAlphaComponent(0.35)
        registrationButton.layer.cornerRadius = 12
    }
    
    private func isUserExist(candidat: User) -> Bool {
        var result = false
        for user in users {
            if user.login == candidat.login {
                showAlert(title: "Warning", message: "User with this email already exists")
                result = true
            } else { result = false }
        }
        return result
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
