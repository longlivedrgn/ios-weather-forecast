//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    private let networkModel = NetworkModel()
    private lazy var network = WeatherAPIManager(networkModel: networkModel)
    
    private var weatherController = WeatherController()
    private var weatherCollectionView: UICollectionView!
    private lazy var forecastWeatherDataSource = makeForecastWeatherDatasource()
    private lazy var currentWeatherDataSource = makeCurrentWeatherDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        collectionViewDelegate()
        print("viewDidLoad()")
    }
}

extension WeatherViewController {
    private func configureHierarchy() {
        weatherCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherCollectionView)
        weatherCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        weatherCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        weatherCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        weatherCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // 처음 빌드될 때 아직 채워지지 않아서 0이 나온다..
        let numberOfItems = CGFloat(weatherController.fiveForecast.count)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .absolute(100))
        let headerItem = NSCollectionLayoutItem(layoutSize: headerSize)
        headerItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        let totalHeaderItemSize = headerItem.contentInsets.top + headerItem.contentInsets.bottom + headerItem.layoutSize.heightDimension.dimension
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        
        let totalItemSize = item.contentInsets.top + item.contentInsets.bottom + item.layoutSize.heightDimension.dimension
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(totalItemSize * numberOfItems + totalHeaderItemSize))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [headerItem, item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func makeForecastWeatherDatasource() -> UICollectionViewDiffableDataSource<Section, WeatherController.FiveDaysForecast> {
        let cellRegistration = UICollectionView.CellRegistration<CurrentWeatherCollectionViewCell, WeatherController.FiveDaysForecast> { (cell, indexPath, fiveDaysForecast) in
            cell.temperatureLabel.text = "\(fiveDaysForecast.temperature)°"
            cell.weatherIconImage.image = fiveDaysForecast.image
            let date = self.changeDateFormat(of: fiveDaysForecast.date)
            cell.dateLabel.text = "\(date)"
        }
        
        forecastWeatherDataSource = UICollectionViewDiffableDataSource(collectionView: weatherCollectionView){ collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        return forecastWeatherDataSource
    }
    
    private func makeCurrentWeatherDataSource() -> UICollectionViewDiffableDataSource<Section, WeatherController.CurrentWeather> {
        let headerRegistration = UICollectionView.CellRegistration<CurrentWeatherHeaderCell, WeatherController.CurrentWeather> {cell, indexPath, currentWeather in
            cell.weatherIconImage.image = self.weatherController.currentWeather?.image
            cell.addressLabel.text = self.weatherController.currentWeather?.address
            
            let maximumTemperature = self.weatherController.currentWeather?.temperatures?.maximumTemperature ?? 0
            let minimumTemperature = self.weatherController.currentWeather?.temperatures?.minimumTemperature ?? 0
            let currentTemperature = self.weatherController.currentWeather?.temperatures?.currentTemperature ?? 0
            
            cell.minimumMaximumTemperatureLabel.text = "최저 \(minimumTemperature)° 최고 \(maximumTemperature)°"
            cell.CurrentTemperatureLabel.text = "\(currentTemperature)°"
        }
        
        currentWeatherDataSource = UICollectionViewDiffableDataSource(collectionView: weatherCollectionView){ collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: itemIdentifier)
        }
        
        return currentWeatherDataSource
    }
    
    private func applyForecastSnapShot(animatingDifferences: Bool = true) {
        var forecastWeathersnapShot =  NSDiffableDataSourceSnapshot<Section, WeatherController.FiveDaysForecast>()
        forecastWeathersnapShot.appendSections([.main])
        forecastWeathersnapShot.appendItems(weatherController.fiveForecast)
        forecastWeatherDataSource.apply(forecastWeathersnapShot, animatingDifferences: true)
    }
    
    private func applyCurrentSnapShot(animatingDifference: Bool = true) {
        var currentWeathersnapShot =  NSDiffableDataSourceSnapshot<Section, WeatherController.CurrentWeather>()
        currentWeathersnapShot.appendSections([.main])
        let currentWeathers = [weatherController.currentWeather!]
        currentWeathersnapShot.appendItems(currentWeathers)
        currentWeatherDataSource.apply(currentWeathersnapShot, animatingDifferences: true)
    }
    
    private func collectionViewDelegate() {
        weatherController.currentWeatherDelegate = self
        weatherController.fiveDaysForecastDelegate = self
    }
    
    private func changeDateFormat(of input: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: input)!
        
        let changedDateFormatter = DateFormatter()
        changedDateFormatter.dateFormat = "MM/dd(EEEEE) HH시"
        changedDateFormatter.locale = Locale(identifier: "ko_KR")
        
        let changedDate = changedDateFormatter.string(from: date)
        
        return changedDate
    }
}

extension WeatherViewController: CurrentWeatherDelegate {

    func notifyToUpdateCurrentWeather() {
        print("notifyToUpdateCurrentWeather")
        applyCurrentSnapShot()
    }
}

extension WeatherViewController: FiveDaysForecastDelegate {

    func notifyToUpdateFiveDaysForecast() {
        print("notifyToUpdateCurrentWeather")
        applyForecastSnapShot()
    }
}
