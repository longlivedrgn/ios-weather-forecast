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
        print("Cell register하기")
        self.weatherCollectionView.register(CurrentWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "CurrentWeatherCell")
        self.weatherCollectionView.register(CurrentWeatherHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CurrentWeatherHeaderView")
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
        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "CurrentWeatherCell", for: indexPath) as! CurrentWeatherCollectionViewCell
        let array = weatherController.fiveForecast
        cell.temperatureLabel.text = "\(array[indexPath.row].temperature)"
        cell.dateLabel.text = array[indexPath.row].date
        cell.weatherIconImage.image = array[indexPath.row].image
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherController.fiveForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            print("Asdf")
            let headerView = weatherCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CurrentWeatherHeaderView", for: indexPath)
            
            guard let headerView = headerView as? CurrentWeatherHeaderView else { return UICollectionReusableView() }
            headerView.weatherIconImage.image = weatherController.currentWeather?.image
            headerView.addressLabel.text = weatherController.currentWeather?.address
            
            let maximumTemperature = weatherController.currentWeather?.temperatures?.maximumTemperature ?? 0
            let minimumTemperature = weatherController.currentWeather?.temperatures?.minimumTemperature ?? 0
            let currentTemperature = weatherController.currentWeather?.temperatures?.currentTemperature ?? 0
            
            headerView.minimumMaximumTemperatureLabel.text = "최저 \(minimumTemperature) 최고 \(maximumTemperature)"
            
            headerView.CurrentTemperatureLabel.text = "\(currentTemperature)"
            return headerView
        default:
            print("Asdf")
            return UICollectionReusableView()
        }
    }
}

