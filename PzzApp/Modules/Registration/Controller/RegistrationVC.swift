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
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    
    var users: Results<User>!
    var closure: ((User) -> ())?
    
    private let storage = StorageService.shared
    private let apiManager: Fetch = APIManager()
    
    
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
    @IBAction func registrationButtonTapped() {
        guard let phone = phoneTextField.text else { return }
        apiManager.getPassword(phone: phone) { [weak self] message, error in
            guard let self = self else { return }
            let user = User()
            user.login = phone
            user.password = ""
            if !self.isUserExist(candidat: user) {
                self.storage.save(user)
                self.closure?(user)
                self.navigationController?.popToRootViewController(animated: true)
            } else { return }
        }
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
        phoneTextField.layer.cornerRadius = 12
        phoneTextField.layer.cornerRadius = 12
        phoneTextField.backgroundColor = #colorLiteral(red: 0.9794260859, green: 0.939825058, blue: 0.9189633727, alpha: 1)
        phoneTextField.clipsToBounds = true
        phoneTextField.font = Global.mainFontWithSize(size: 16)
        registrationButton.backgroundColor = .white.withAlphaComponent(0.35)
        registrationButton.layer.cornerRadius = 12
    }
    
    private func isUserExist(candidat: User) -> Bool {
        var result = false
        for user in users {
            if user.login == candidat.login {
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
