import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    let locationManager = CLLocationManager()
    let service = WeatherService()

    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpServices()
    }

    private func setUpServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        service.delegate = self
    }

    // See TODO in delegate: If WeatherService changes how it gets the weather then this
    // method will have to change. If the data was passed via the delegate then this meth wouldn't have to change at all!
    private func updateUIWithWeatherData() {
        guard let currentLocalWeather = service.currentLocalWeather else { return }
        cityLabel.text = currentLocalWeather.name
        temperatureLabel.text = "\(service.temperature)°"
        weatherIcon.image = UIImage(named: service.weatherIconName)
    }
    
    private func displayErrorMessage(message: String) {
        cityLabel.text = message
    }
}

extension WeatherViewController: ChangeCityDelegate {
    func userEnteredANewCityName(city: String) {
        cityLabel.text = city
        service.fetchWeatherData(for: city)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()

            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)

            service.fetchWeatherDataForCoords(latitude: latitude, longitude: longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavaliable"
    }
}

extension WeatherViewController: WeatherServiceDelegate {

    func errorOccurred(errorMessage: String) {
        displayErrorMessage(message: errorMessage)
    }

    func weatherDataUpdated() {
        updateUIWithWeatherData()
    }
}
