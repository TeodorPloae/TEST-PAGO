//
//  ContactNetworkModel.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import Foundation

struct ContactNetworkModel: Codable {
    let id: Int
    let name, email: String
    let status: Status
}

enum Status: String, Codable {
    case active = "active"
    case inactive = "inactive"
}
