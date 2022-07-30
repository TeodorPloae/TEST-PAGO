//
//  ContactsRepository.swift
//  Test_Pago
//
//  Created by Teodor Ploae on 30.07.2022.
//

import Foundation
import Alamofire

class ContactsRepository {
    private let requestUrl = "https://gorest.co.in/public/v2/users"
    
    func getContacts(completion: @escaping (Result<[ContactNetworkModel], AFError>) -> Void) {
        AF.request(requestUrl, method: .get).responseDecodable(of: [ContactNetworkModel].self) { response in
            completion(response.result)
        }
    }
}
