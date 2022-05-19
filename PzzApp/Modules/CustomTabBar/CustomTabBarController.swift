//
//  CustomTabBarView.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 17.03.2022.
//

import UIKit
import RealmSwift

class CustomTabBarController: UITabBarController {

    private var didSetupShadow = false
    private var basketView = BasketIcon().loadView() as! BasketIcon
    private var basketElements: Results<BasketElement>!
    private var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barStyle = .black
        delegate = self
        basketElements = realm.objects(BasketElement.self)
        setupTabs()
        checkUpdates()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupAppearance()
        tabBar.standardAppearance.stackedItemPositioning = .centered
        tabBar.standardAppearance.stackedItemWidth = 60
        tabBar.standardAppearance.stackedItemSpacing = 60
        tabBar.standardAppearance.backgroundColor = #colorLiteral(red: 0.9421315789, green: 0.2903913856, blue: 0.1394482851, alpha: 1)
        if !didSetupShadow {
            setTabBarShadow()
            didSetupShadow = true
        }
        super.viewDidAppear(animated)
    }

    private func setupTabs() {
        guard
            let storyboard1 = UIStoryboard(name: "Products", bundle: .main).instantiateInitialViewController(),
            let main = storyboard1.storyboard?.instantiateViewController(withIdentifier: "products"),
            let basket = UIStoryboard(name: "Basket", bundle: .main).instantiateInitialViewController(),
            let user = UIStoryboard(name: "User", bundle: .main).instantiateInitialViewController()
        else { return }
        viewControllers = [main, basket, user]

        setupTabItemViews()
    }

    private func setupTabItemViews() {
        let basket = basketView
        let pizzaImage = resizeImage(image: UIImage(named: "pizzaImage")!, targetSize: CGSize(width: 40, height: 40))
        let userImage = resizeImage(image: UIImage(named: "userImage")!, targetSize: CGSize(width: 50, height: 50))
        let images = [pizzaImage, basket.asImage(), userImage]
        
        for i in (viewControllers ?? []).indices {
            viewControllers?[i].tabBarItem = UITabBarItem(title: nil, image: images[i], tag: i)
        }
    }

    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = .white
        itemAppearance.selected.iconColor = .black
    }

    private func setupAppearance() {
        var newBarHeight: CGFloat = 86.0
        newBarHeight += UIApplication.shared.delegate?.window??.windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
//        newBarHeight += UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        tabBar.frame.size.height = newBarHeight
        tabBar.frame.origin.y = view.frame.height - newBarHeight

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = #colorLiteral(red: 0.9421315789, green: 0.2903913856, blue: 0.1394482851, alpha: 1)
        appearance.shadowColor = nil
        appearance.shadowImage = nil

        setTabBarItemColors(appearance.stackedLayoutAppearance)
        setTabBarItemColors(appearance.inlineLayoutAppearance)
        setTabBarItemColors(appearance.compactInlineLayoutAppearance)

        tabBar.standardAppearance = appearance

        tabBar.items?.forEach {
            $0.imageInsets = UIEdgeInsets(
                top: 4,
                left: 0,
                bottom: -4,
                right: 0
            )
        }
    }

    private func setTabBarShadow() {
        let path = UIBezierPath(
            roundedRect: tabBar.layer.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(
                width: 100.0,
                height: 100.0
            )
        )
        
        let maskLayer = CAShapeLayer()
       
        maskLayer.path = path.cgPath
        maskLayer.fillColor = #colorLiteral(red: 0.9421315789, green: 0.2903913856, blue: 0.1394482851, alpha: 1).cgColor
        maskLayer.zPosition -= 1

        let containerLayer = CALayer()
        containerLayer.shadowPath = path.cgPath
        containerLayer.shadowColor = UIColor.black.cgColor
        containerLayer.shadowOpacity = 1
        containerLayer.shadowRadius = 2
        containerLayer.shadowOffset = CGSize(width: 0, height: -1)
        containerLayer.zPosition = maskLayer.zPosition - 1

        tabBar.layer.insertSublayer(maskLayer, below: tabBar.layer)
        tabBar.layer.insertSublayer(containerLayer, below: maskLayer)
    }
    
    private func checkUpdates() {
        notificationToken = basketElements.observe { [weak self] change in
            switch change {
            case .error(let error):
                print(#file, #line, error.localizedDescription)
            default:
                self?.basketView.countLabel.text = "\(self?.basketElements.count ?? 404)"
                self?.tabBar.items?[1].image = self?.basketView.asImage()
            }
        }
    }
}

extension CustomTabBarController: UITabBarControllerDelegate {
    
}
