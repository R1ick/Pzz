//
//  UserVC.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 25.03.2022.
//

import SwiftUI
import RealmSwift

class UserVC: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var customNavBar: CustomNavBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let storage: UserInfoStorable = StorageService.shared
    var user: User?
    var deliveryTime = "45"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        user = Global.currentUser
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserInfo()
        tableView.reloadData()
    }
}

//MARK: @IBAction's
extension UserVC {
    @IBAction func editNameButtonTapped() {
        usernameLabel.isHidden = true
        let textField = UITextField(frame: usernameLabel.frame)
        textField.tag = 0
        scrollView.addSubview(textField)
        textField.delegate = self
        textField.font = Global.mainFontWithSize(size: 24)
        textField.layer.position = usernameLabel.layer.position
        textField.text = usernameLabel.text
        textField.backgroundColor = .clear
        textField.becomeFirstResponder()
    }
    @IBAction func editPhoneButtonTapped() {
        phoneLabel.isHidden = true
        let textField = UITextField(frame: phoneLabel.frame)
        textField.tag = 1
        scrollView.addSubview(textField)
        textField.delegate = self
        textField.font = Global.mainFontWithSize(size: 18)
        textField.layer.position = phoneLabel.layer.position
        textField.text = phoneLabel.text
        textField.backgroundColor = .clear
        textField.becomeFirstResponder()
    }
    @IBAction func userDataRulesButtonTapped() {
        guard let url = URL(string: "https://pzz.by/privacy-policy") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func servicesRulesButtonTapped() {
        guard let url = URL(string: "https://pzz.by/rules") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func payMethodsButtonTapped() {
        guard let url = URL(string: "https://pzz.by/payments") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func deliveryAreaButtonTapped(_ sender: Any) {
        let mapVC = MapVC()
        self.navigationController?.show(mapVC, sender: nil)
    }
    @IBAction func logOutTapped() {
        UserDefaults.standard.set(false, forKey: "isLogin")
        let login = UIStoryboard(name: "Login", bundle: .main).instantiateInitialViewController()
        sceneDelegate.window?.rootViewController = login
    }
    
    //MARK: SegueActions to HostingControllers
    @IBSegueAction func toAdressesSegueAction(_ coder: NSCoder) -> UIViewController? {
        guard let user = user,
              let info = user.userInfo,
              let adresses = user.userInfo?.addresses
        else { return nil }
        var array = [Adress]()
        for item in adresses {
            array.append(item)
        }
        let addressesView = AdressesView(info: info).environmentObject(user)
        return UIHostingController(coder: coder, rootView: addressesView)
    }
    @IBSegueAction func toHistorySegueAction(_ coder: NSCoder) -> UIViewController? {
        guard  let info = user?.userInfo else { return nil }
        return UIHostingController(coder: coder, rootView: HistoryView(info: info))
    }
    @IBSegueAction func toSettingsSegueAction(_ coder: NSCoder) -> UIViewController? {
        guard let settings = user?.userInfo?.orderSettings else { return nil }
        let settingsView = OrderSettingsView().environmentObject(settings)
        return UIHostingController(coder: coder, rootView: settingsView)
    }
}


extension UserVC {
    private func setupUI() {
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 10
        customNavBar.filterButton.isHidden = true
        navigationController?.viewControllers = [self]
        timeLabel.text = deliveryTime + " минут"
        descriptionLabel.text = "если мы не доставим заказ за \(deliveryTime) минут вы получите одну пиццу из заказа бесплатно"
    }
    
    private func updateUserInfo() {
        if let info = user?.userInfo {
            let name = info.name
            let phone = info.phone
            usernameLabel.text = name
            phoneLabel.text = phone
        } else {
            usernameLabel.text = "Username"
            phoneLabel.text = "+375447556655"
        }
    }
}

//MARK: TableView
extension UserVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.font = Global.mainFontWithSize(size: 24)
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.6389834881, blue: 0.4692313671, alpha: 1).withAlphaComponent(0.5)
        switch indexPath.row {
        case 0: cell.textLabel?.text = "Мои адреса"
        case 1: cell.textLabel?.text = "История заказов"
        case 2: cell.textLabel?.text = "Настройки заказа"
        default: break
        }
        
        return cell
    }
}

extension UserVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "toAdresses", sender: nil)        case 1:
            performSegue(withIdentifier: "toHistory", sender: nil)
        case 2:
            performSegue(withIdentifier: "toSettings", sender: nil)
        default: break
        }
    }
}

//MARK: TextFieldDelegate
extension UserVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            textField.isHidden = true
            textField.resignFirstResponder()
            usernameLabel.isHidden = false
            usernameLabel.text = textField.text
            guard let user = user else { return }
            storage.updateUserInfo(for: user, with: [.name(textField.text ?? "Error name")])
        case 1:
            textField.isHidden = true
            textField.resignFirstResponder()
            phoneLabel.isHidden = false
            phoneLabel.text = textField.text
            guard let user = user else { return }
            storage.updateUserInfo(for: user, with: [.phone(textField.text ?? "Error phone")])
        default: break
        }
    }
}
