//
//  BasketVC.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 26.03.2022.
//

import UIKit
import RealmSwift

final class BasketVC: BaseViewController {

    @IBOutlet weak var headerView: CustomNavBar!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainOrderLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var makeOrderButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    private let apiManager: Fetch = APIManager()
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let storage = StorageService.shared
    private var settings: OrderSettings?
    private var totalAmout: Double = 0
    private var currentDeliveryTime = ""
    private var foods: Results<BasketElement>!
    private var notificationToken: NotificationToken?
    private var user: User?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell(tableView)
        setupUI()
        getDeliveryTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foods = realm.objects(BasketElement.self)
        tableView.reloadData()
        updateMenu()
    }
}

//MARK: - @IBAction's
extension BasketVC {
    @IBAction func makeOrderButtonTapped() {
        if isOrderAvailible() {
            let sem = DispatchSemaphore(value: 0)
            sem.signal()
            DispatchQueue.main.async { [unowned self] in
                sem.wait()
                saveToHistory()
                sem.signal()
            }
            Thread.sleep(forTimeInterval: 0.2)
            DispatchQueue.main.async { [unowned self] in
                sem.wait()
                makeOrder()
                sem.signal()
            }
            DispatchQueue.main.async { [unowned self] in
                sem.wait()
                presentInfoAlert()
            }
        }
        feedbackGenerator.impactOccurred()
    }
}

//MARK: - UITableViewDataSource
extension BasketVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BasketCell
        let food = foods[indexPath.row]
        cell.food = food
        cell.configure()
        cell.count = food.count
        cell.nameLabel.text = food.name
        cell.sizeLabel.text = food.size
        cell.countLabel.text = "\(food.count)"
        checkFood(for: cell)
        cell.priceLabel.text = String(format: "%.2f",food.price)
        totalAmout += food.price
        updateTotalAmout()
        
        return cell
    }
}
//MARK: - UITableViewDelegate
extension BasketVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            guard let food = self?.foods[indexPath.row] else { return }
            self?.storage.delete(food)
        }
        let label = UILabel()
        label.text = "Удалить"
        label.textColor = .white
        label.font = Global.mainFontWithSize(size: 12)
        label.sizeToFit()
        deleteAction.image = UIImage(view: label)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

//MARK: UI
extension BasketVC {
    private func registerCell(_ tableView: UITableView) {
        let nib = UINib(nibName: "BasketCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    private func setupUI() {
        foods = realm.objects(BasketElement.self)
        user = Global.currentUser
        
        headerView.filterButton.isHidden = true
        makeOrderButton.layer.cornerRadius = 12
        makeOrderButton.layer.masksToBounds = true
        totalView.layer.masksToBounds = false
        totalView.layer.shouldRasterize = true
        totalView.layer.shadowColor = UIColor.black.cgColor
        totalView.layer.shadowOpacity = 0.5
        totalView.layer.shadowOffset = CGSize(width: 0, height: -5.0)
        totalView.layer.shadowRadius = 3.0
        settingsButton.menu = createMenu()
        settingsButton.showsMenuAsPrimaryAction = true
    }
    
    private func presentInfoAlert() {
        guard let adresses = user?.userInfo?.addresses else { return }
        for adress in adresses {
            if let settings = user?.userInfo?.orderSettings,
               let id = user?.userInfo?.currentAdressID,
               adress.id == id {
                let title = "Ваш заказ"
                var message = ""
                switch settings.time {
                case .at45, .at60:
                    message = "Курьер прибудет по адресу: \(adress.street) \(adress.building) - \(adress.flat) через \(currentDeliveryTime) минут."
                case .pre:
                    guard let date = settings.preOrder else { return }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yy HH:mm"
                    let orderDate = formatter.string(from: date)
                    guard let space = orderDate.firstIndex(of: " ") else { return }
                    let one = orderDate[..<space]
                    let two = orderDate[space...]
                    message = " \(one) в\(two)\nКурьер прибудет по адресу: \(adress.street) \(adress.building) - \(adress.flat)"
                }
                self.showAlert(title: title, message: message)
            }
        }
    }

    private func presentPreOrderDateAlert() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 300,height: 50)
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        vc.view.addSubview(datePicker)
        let dateAlert = UIAlertController(title: "Введите дату и время", message: "", preferredStyle: .alert)
        dateAlert.setValue(vc, forKey: "contentViewController")
        dateAlert.addAction(UIAlertAction(title: "Готово", style: .default, handler: { [weak self] _ in
            self?.storage.updateOrderSettings(preOrder: datePicker.date)
        }))
        dateAlert.addAction(UIAlertAction(title: "Отменить", style: .destructive, handler: nil))
        self.present(dateAlert, animated: true)
    }
    
    private func updateTotalAmout() {
        totalAmout = 0
        for food in foods {
            totalAmout += food.price
        }
        totalLabel.text = String(format: "%.2f", totalAmout)
        mainOrderLabel.text = foods.isEmpty ? "Ваша корзина пуста" : "Ваш заказ"
    }
    
    //MARK: Notification
    private func checkFood(for cell: BasketCell) {
        notificationToken = foods.observe { [weak self] change in
            switch change {
            case .initial(_):
                return
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                if !insertions.isEmpty {
                    guard let index = insertions.first else { return }
                    self?.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    self?.updateTotalAmout()
                }
                if deletions.isEmpty {
                    if !modifications.isEmpty {
                        guard let index = modifications.first else { return }
                        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        self?.updateTotalAmout()
                    }
                }
                if !deletions.isEmpty {
                    guard let index = deletions.first else { return }
                    self?.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    self?.updateTotalAmout()
                }
            case .error(_):
                return
            }
        }
    }

    //MARK: Menu & make order
    private func updateMenu() {
        settingsButton.menu = createMenu()
    }
    
    private func createMenu() -> UIMenu {
        guard let settings = user?.userInfo?.orderSettings else { fatalError("Cannot find order settings") }
        let clockActions: [UIAction] = [
            UIAction(title: OrderTime.allCases.first?.raw ?? "В течении 45 минут",
                     state: settings.time == .at45 || settings.time == .at60 ? .on : .off) { [weak self] action in
                         self?.storage.updateOrderSettings(time: .at45, preOrder: nil)
                self?.updateMenu()
            },
            UIAction(title: OrderTime.allCases.last?.raw ?? "Предзаказ",
                     state: settings.time == .pre ? .on : .off) { [weak self] action in
                print("Предзаказ")
                self?.presentPreOrderDateAlert()
                self?.storage.updateOrderSettings(time: .pre)
                self?.updateMenu()
            }
        ]
        let deliveryActions: [UIAction] = [
            UIAction(title: Delivery.allCases.first?.raw ?? "Привезите как обычно",
                     state: settings.delivery == .normal ? .on : .off) { [weak self] _ in
                print("Привезите")
                self?.storage.updateOrderSettings(delivery: .normal)
                self?.updateMenu()
            },
            UIAction(title: Delivery.allCases.last?.raw ?? "Доставка без контакта с курьером",
                     state: settings.delivery == .withoutContact ? .on : .off) { [weak self] _ in
                print("контакта")
                self?.storage.updateOrderSettings(delivery: .withoutContact)
                self?.updateMenu()
            }
        ]
        let paymentActions: [UIAction] = [
            UIAction(title: PaymentMethod.allCases.first?.raw ?? "Наличными",
                     state: settings.payment == .cash ? .on : .off) { [weak self] _ in
                print("Наличными")
                self?.storage.updateOrderSettings(payment: .cash)
                self?.updateMenu()
            },
            UIAction(title: PaymentMethod.allCases[1].raw,
                     state: settings.payment == .card ? .on : .off) { [weak self] _ in
                print("Картой")
                self?.storage.updateOrderSettings(payment: .card)
                self?.updateMenu()
            },
            UIAction(title: PaymentMethod.allCases[2].raw) { [weak self] _ in
                self?.showAlert(title: "Функция находится в разработке")
//                self?.storage.updateOrderSettings(payment: .online)
            },
            UIAction(title: PaymentMethod.allCases.last?.raw ?? "Халва") { [weak self] _ in
                self?.showAlert(title: "Функция находится в разработке")
//                self?.storage.updateOrderSettings(payment: .halva)
            }
        ]
        let clockMenu = UIMenu(title: "Время заказа", children: clockActions)
        let deliveryMenu = UIMenu(title: "Доставка", children: deliveryActions)
        let paymentMenu = UIMenu(title: "Способ оплаты", children: paymentActions)
        let mainMenu = UIMenu(title: "Настройки заказа", children: [clockMenu, deliveryMenu, paymentMenu])
        
        return mainMenu
    }
    
    private func isOrderAvailible() -> Bool {
        if let count = user?.userInfo?.addresses.count, count < 1 {
            showAlert(title: "Внимание!", message: "Добавьте адрес доставки!")
            return false
        } else {
            return true
        }
    }
    
    private func makeOrder() {
        //make order request
        storage.cleanBusket()
    }
    
    private func saveToHistory() {
        let order = Order()
        let history = List<HistoryElement>()
        var total = 0.0
        for food in foods {
            let elem = HistoryElement()
            elem.name = food.name
            elem.count = food.count
            elem.price = food.price
            total += food.price
            history.append(elem)
        }
        order.products = history
        order.total = total
        storage.saveToHistory(order)
    }
    
    //MARK: - time request
    private func getDeliveryTime() {
        apiManager.getDeliveryTime { [weak self] time, error in
            if let _ = error {
                print(error)
            }
            if let time = time {
                self?.currentDeliveryTime = time
            }
        }
    }
}
