//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    private let networkModel = NetworkModel()
    private lazy var network = WeatherAPIManager(networkModel: networkModel)
    
    private var weatherController = WeatherController()
    
    private var weatherCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        register()
        collectionViewDelegate()
    }
}

extension WeatherViewController {
    private func configureHierarchy() {
        weatherCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(weatherCollectionView)
    }
    
    private func register() {
        self.weatherCollectionView.register(FiveDaysForecastCell.self, forCellWithReuseIdentifier: "FiveDaysForecastCell")
        self.weatherCollectionView.register(CurrentWeatherHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CurrentWeatherHeaderCell")
    }
    
    private func collectionViewDelegate() {
        weatherCollectionView.dataSource = self
        weatherController.currentWeatherDelegate = self
        weatherController.fiveDaysForecastDelegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}

extension WeatherViewController: CurrentWeatherDelegate {

    func notifyToUpdateCurrentWeather() {
        weatherCollectionView.reloadData()
    }
}

extension WeatherViewController: FiveDaysForecastDelegate {

    func notifyToUpdateFiveDaysForecast() {
//        weatherCollectionView.reloadData()
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "FiveDaysForecastCell", for: indexPath) as! FiveDaysForecastCell
        let fiveDaysForecasts = weatherController.fiveDaysForecast
        
        let temperature = fiveDaysForecasts[indexPath.row].temperature
        cell.temperatureLabel.text = "\(temperature)°"
        
        let date = fiveDaysForecasts[indexPath.row].date
        let transformedDate = date.changeDateFormat()
        cell.dateLabel.text = transformedDate
        
        let weatherIconImage = fiveDaysForecasts[indexPath.row].image
        cell.weatherIconImage.image = weatherIconImage
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherController.fiveDaysForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = weatherCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CurrentWeatherHeaderCell", for: indexPath) as! CurrentWeatherHeaderCell
            headerView.currentWeather = weatherController.currentWeather
            return headerView
        default:
            print("Asdf")
            return UICollectionReusableView()
        }
    }
}

