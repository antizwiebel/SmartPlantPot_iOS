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
    case plantUpdate = "http://www.trabby.at/spp/api/plant/update_from_app.php"
    case history = "http://www.trabby.at/spp/api/measurement/read_by_plant_sorted.php?plant_id=1"
}

class NetworkManager {

    // MARK: - Properties

    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager(baseURL: URL(string: "http://www.trabby.at/spp/api/")!)

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

    func requestHistoryPage(success: @escaping (_ response: HistoryPageResponse) -> Void,
                         failure: @escaping (_ error: String?) -> Void) {
        request(forURL: ApiEndpoints.history.rawValue, success: success, failure: failure, decodable: HistoryPageResponse.self)
    }

    func requestPlantUpdate(withPlantModel: Plant, success: @escaping () -> Void,
                            failure: @escaping (_ error: String?) -> Void) {
        let parameters: [String: Any] = [
            "id": withPlantModel.id,
            "name": withPlantModel.name,
            "date_added": withPlantModel.dateAdded,
            "owner_id": 1,
            "status": withPlantModel.status?.rawValue,
            "temperature_treshold": withPlantModel.temperatureTreshold,
            "humidity_treshold": withPlantModel.humidityTreshold,
            "active": 1,
            "type": "home"
        ]

        Alamofire.request(ApiEndpoints.plantUpdate.rawValue, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            if let error = response.error {
                failure(error.localizedDescription)
            } else {
                success()
            }
        }
    }

    private func request<T>(forURL url: String, success: @escaping (_ response: T) -> Void,
                            failure: @escaping (_ error: String?) -> Void, decodable: T.Type) where T: Decodable {
        Alamofire.request(url).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let responseValue = try decoder.decode(decodable.self, from: data)
                success(responseValue)
            } catch let error {
                print(error)
                failure(response.error?.localizedDescription)
            }
        }
    }
}
