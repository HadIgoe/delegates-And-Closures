//
//  NetworkService.swift
//  Clima
//
//  Created by Hadley Igoe on 2019-11-07.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation
import Alamofire



class NetworkService {
    
    var returnNetworkRequest: ((_ result: Data)->())?
    
    func fetchWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess{
                guard let weatherJSON = response.data else {return}
                self.returnNetworkRequest?(weatherJSON)
            }
        }
    }
}
