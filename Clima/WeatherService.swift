import Foundation
import Alamofire

protocol WeatherServiceDelegate: AnyObject {
    // TODO: pass the weather data to remove another dependency
    func weatherDataUpdated()
    func errorOccurred(errorMessage: String)
}

struct CurrentLocalWeather: Codable {
    var cod: Int
    var main: Main
    var name: String
}

struct Main: Codable {
    var temp: Double
}

class WeatherService {

    // Constants required for the API
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "bf01c24469143b47cc42f0c971f583cc"

    weak var delegate: WeatherServiceDelegate?

    var temperature = 0
    var weatherIconName = ""
    var currentLocalWeather: CurrentLocalWeather?

    func fetchWeatherData(for city: String) {
        let params = ["q" : city, "appid" : APP_ID]
        fetchData(params: params)
    }

    func fetchWeatherDataForCoords(latitude: String, longitude: String) {
        let params = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
        fetchData(params: params)
    }

    private func fetchData(params : [String : String]) {
        Alamofire.request(WEATHER_URL, method: .get, parameters: params).responseJSON { response in
            if response.result.isSuccess{
                guard let data = response.data else {return}
                if let json = try? JSONDecoder().decode(CurrentLocalWeather.self, from: data) {
                    self.currentLocalWeather = json
                    guard let currentWeather = self.currentLocalWeather else { return }
                    self.temperature = Int(json.main.temp - 273.15)
                    self.weatherIconName = self.updateWeatherIcon(condition: currentWeather.cod)
                    self.delegate?.weatherDataUpdated()
                } else {
                    self.delegate?.errorOccurred(errorMessage: "Weather Unavailable")
                }
            }
        }
    }

    private func updateWeatherIcon(condition: Int) -> String {
        switch (condition) {

            case 0...300 :
                return "tstorm1"

            case 301...500 :
                return "light_rain"

            case 501...600 :
                return "shower3"

            case 601...700 :
                return "snow4"

            case 701...771 :
                return "fog"

            case 772...799 :
                return "tstorm3"

            case 800 :
                return "sunny"

            case 801...804 :
                return "cloudy2"

            case 900...903, 905...1000  :
                return "tstorm3"

            case 903 :
                return "snow5"

            case 904 :
                return "sunny"

            default :
                return "dunno"
        }
    }
}
