//
//  NetworkService.swift
//  Clima
//
//  Created by Hadley Igoe on 2019-11-07.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkServiceDelegate {
    func returnNetworkRequest(result: Data)
}

class NetworkService {
    
    var delegate: NetworkServiceDelegate?

    func fetchWeatherData(url: String, parameters: [String: String]) {
         Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess{
                guard let weatherJSON = response.data else {return}
                self.delegate?.returnNetworkRequest(result: weatherJSON)
            }
        }
    }
}
