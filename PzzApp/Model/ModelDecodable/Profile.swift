//
//  Profile.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 22.05.2022.
//

import Foundation

struct Profile: Decodable {
    let phone: String?
    let name: String?
    let ordersCount: Int?
    let smsNumPzz: Int?
    let smsNumGdz: Int?
    let createdAt: String?
    let updatedAt: String?
    let isPassProtectedPzz: Int?
    let isPassProtectedGdz: Int?
    let flags: String?
    let phoneFormatted: String?
    let addresses: [PzzAddress]?
}


struct Street: Decodable {
    let id: Int?
    let title: String?
    let pattern: String?
    let defaultGeo: String?
    let useDefaultGeo: Bool?
    let active: Int?
    let createdAt: String?
    let updatedAt: String?
    let titleShort: String?
}

struct House: Decodable {
    let id: Int?
    let streetId: Int?
    let title: String?
    let active: Int?
    let geo: String?
    let regionId: Int?
    let pattern: String?
    let reversedGeo: String?
    let region: Region?
}
struct Region: Decodable {
    let id: Int?
    let title: String?
    let pizzeriaId: Int?
    let rules: [Rule]?
    let pizzeria: Pizzeria?
    let street: Street?
}
struct Rule: Decodable {
    let id: Int?
    let scenarioId: Int?
    let regionId: Int?
    let pizzeriaId: Int?
    let onStop: Int?
    let scenario: Scenario?
}

struct Scenario: Decodable {
    let id: Int?
    let title: String?
    let priority: Int?
    let day1: Int?
    let day2: Int?
    let day3: Int?
    let day4: Int?
    let day5: Int?
    let day6: Int?
    let day0: Int?
    let dynamic: Int?
    let enabled: Bool?
    let active: Int?
    let createdAt: String?
    let updated_at: String?
    let day1Start: String?
    let day1End: String?
    let day2Start: String?
    let day2End: String?
    let day3Start: String?
    let day3End: String?
    let day4Start: String?
    let day4End: String?
    let day5Start: String?
    let day5End: String?
    let day6Start: String?
    let day6End: String?
    let day0Start: String?
    let day0End: String?
}
struct Pizzeria: Decodable {
    let id: Int?
    let title: String?
    let streetId: Int?
    let houseId: Int?
    let active: Int?
    let workTimeInfo: WorkTimeInfo?
}

struct WorkTimeInfo: Decodable {
    let closedAt: String?
    let openedAt: String?
    let isWorkDay: Bool?
    let isWorkingNow: Bool?
}
