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
    private lazy var dataSource = makeDataSource()
    
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(48))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .absolute(100))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "Header", alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, WeatherController.FiveDaysForecast> {
        let cellRegistration = UICollectionView.CellRegistration<CurrentWeatherCollectionViewCell, WeatherController.FiveDaysForecast> { (cell, indexPath, fiveDaysForecast) in
            cell.temperatureLabel.text = "\(fiveDaysForecast.temperature)°"
            cell.weatherIconImage.image = fiveDaysForecast.image
            cell.dateLabel.text = "\(fiveDaysForecast.date)"
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<CurrentWeatherHeaderView>(elementKind: "Header") { headerView, elementKind, indexPath in
            headerView.weatherIconImage.image = self.weatherController.currentWeather?.image
            headerView.addressLabel.text = self.weatherController.currentWeather?.address
            
            let maximumTemperature = self.weatherController.currentWeather?.temperatures?.maximumTemperature ?? 0
            let minimumTemperature = self.weatherController.currentWeather?.temperatures?.minimumTemperature ?? 0
            let currentTemperature = self.weatherController.currentWeather?.temperatures?.currentTemperature ?? 0
            
            headerView.minimumMaximumTemperatureLabel.text = "최저 \(minimumTemperature)° 최고 \(maximumTemperature)°"
            headerView.CurrentTemperatureLabel.text = "\(currentTemperature)°"
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, WeatherController.FiveDaysForecast>(collectionView: weatherCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: WeatherController.FiveDaysForecast) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = { (weatherCollectionView, kind, index) in
            return weatherCollectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }
        
        return dataSource
    }
    
    private func applySnapShot(animatingDifferences: Bool = true) {
        var snapShot =  NSDiffableDataSourceSnapshot<Section, WeatherController.FiveDaysForecast>()
        snapShot.appendSections([.main])
        snapShot.appendItems(weatherController.fiveForecast)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    private func collectionViewDelegate() {
        weatherController.currentWeatherDelegate = self
        weatherController.fiveDaysForecastDelegate = self
    }
}

extension WeatherViewController: CurrentWeatherDelegate {

    func notifyToUpdateCurrentWeather() {
        print("notifyToUpdateCurrentWeather")
        applySnapShot()
    }
}

extension WeatherViewController: FiveDaysForecastDelegate {

    func notifyToUpdateFiveDaysForecast() {
        print("notifyToUpdateCurrentWeather")
        applySnapShot()
    }
}
//
//extension WeatherViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.bounds.width, height: 120)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 100, height: 100)
//    }
//
//}
//
//extension WeatherViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "CurrentWeatherCell", for: indexPath) as! CurrentWeatherCollectionViewCell
//        let array = weatherController.fiveForecast
//        cell.temperatureLabel.text = "\(array[indexPath.row].temperature)"
//        cell.dateLabel.text = array[indexPath.row].date
//        cell.weatherIconImage.image = array[indexPath.row].image
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return weatherController.fiveForecast.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            print("Asdf")
//            let headerView = weatherCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CurrentWeatherHeaderView", for: indexPath)
//            guard let headerView = headerView as? CurrentWeatherHeaderView else { return UICollectionReusableView() }
//            headerView.weatherIconImage.image = weatherController.currentWeather?.image
//            headerView.addressLabel.text = weatherController.currentWeather?.address
//
//            let maximumTemperature = weatherController.currentWeather?.temperatures?.maximumTemperature ?? 0
//            let minimumTemperature = weatherController.currentWeather?.temperatures?.minimumTemperature ?? 0
//            let currentTemperature = weatherController.currentWeather?.temperatures?.currentTemperature ?? 0
//
//            headerView.minimumMaximumTemperatureLabel.text = "최저 \(minimumTemperature) 최고 \(maximumTemperature)"
//
//            headerView.CurrentTemperatureLabel.text = "\(currentTemperature)"
//            return headerView
//        default:
//            print("Asdf")
//            return UICollectionReusableView()
//        }
//    }
//}

