//
//  Networking.swift
//  SmartPot
//
//  Created by Mark on 02.01.20.
//  Copyright © 2020 Mark. All rights reserved.
//

import Foundation
import Alamofire

enum ApiEndpoints: String {
    case homePage = "http://www.trabby.at/spp/api/plant/read.php"
}

class NetworkManager {

    // MARK: - Properties

    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager(baseURL: URL(string: "http://www.trabby.at/spp/api/")!)

        // Configuration
        // ...

        return networkManager
    }()

    // MARK: -

    let baseURL: URL

    // Initialization

    private init(baseURL: URL) {
        self.baseURL = baseURL
    }

    // MARK: - Accessors

    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }

    func requestHomePage(success: @escaping (_ response: HomePageResponse) -> Void,
                         failure: @escaping (_ error: String?) -> Void) {
        request(forURL: ApiEndpoints.homePage.rawValue, success: success, failure: failure, decodable: HomePageResponse.self)
    }

    private func request<T>(forURL url: String, success: @escaping (_ response: T) -> Void,
                            failure: @escaping (_ error: String?) -> Void, decodable: T.Type) where T: Decodable {
        AF.request(url).responseDecodable(of: decodable.self) { response in
            if let responseValue = response.value {
                debugPrint("Response: \(response)")
                DispatchQueue.main.async {
                    success(responseValue)
                }
            } else {
                debugPrint("Error: \(response)")
                failure(response.error?.errorDescription)
                DispatchQueue.main.async {
                    failure(response.error?.errorDescription)
                }
            }
        }
    }
}
