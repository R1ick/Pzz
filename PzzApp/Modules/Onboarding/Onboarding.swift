//
//  Onboarding.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 28.04.2022.
//

import Onboarder
import SwiftUI

struct Onboarding: View {
    let pages: [OBPage] = [
        OBPage(color: .white, imageName: "bottom-pzz", label: ("Добро пожаловать!", "Мы рады, что вы используете наше приложение, давайте посмотрим как им пользоваться!")),
        OBPage(color: .white, imageName: "image1", label: ("Главный экран", "Здесь вы можете выбрать что-нибудь покушать.")),
        OBPage(color: .white, imageName: "image2", label: ("Панель навигации", "Сверху вы можете видеть названия основных категорий продуктов, нажав на любую, вы перейдете к ней.")),
        OBPage(color: .white, imageName: "image3", label: ("Настройки заказа", "В корзине, по нажатию на шестерёнку вам откроется меню, в котором вы сможете настроить доставку заказа на удобное для вас время (настройки сохраняются и на последующие заказы).")),
        OBPage(color: .white, imageName: "image4", label: ("Профиль", "На странице профиля вы можете изменить ваше имя и номер телефона. Также вы можете просмотреть свои адреса, историю заказов и попасть в настройки заказа.")),
        OBPage(color: .white, imageName: "image5", label: ("Настройки заказа", "Все те же настройки как и в корзине, только на весь экран :)")),
        OBPage(color: .white, imageName: "image6", label: ("История заказов", "Здесь вы можете посмотреть когда и что кушали вместе с итоговой суммой.")),
        OBPage(color: .white, imageName: "image7", label: ("Адреса", "Здесь вы можете выбрать текущий адрес доставки, а также добавить несколько дополнительных (для заказа нужен хотя бы один)."))
        ]
    
    var body: some View {
    
        let configuration = OBConfiguration(isSkippable: true,
                                            buttonLabel: "К меню",
                                            textContentHeight: 250,
                                            textContentBackgroundColor: .orange,
                                            textContentCornerRadius: 24,
                                            textContactCorner: .bottomLeft)
        OnboardingView(pages: pages, configuration: configuration)
            .onDisappear {
                UserDefaults.standard.set(true, forKey: "needShowOnboarding")
            }
        
        // Without default configuration
//        OnboardingView(pages: pages)
    }
}
