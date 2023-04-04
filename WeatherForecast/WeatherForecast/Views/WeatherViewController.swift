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
        // 처음 빌드될 때 아직 채워지지 않아서 0이 나온다..
        let numberOfItems = CGFloat(weatherController.fiveForecast.count)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .absolute(100))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "Header", alignment: .top)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        
        let totalItemSize = item.contentInsets.top + item.contentInsets.bottom + item.layoutSize.heightDimension.dimension
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(totalItemSize * numberOfItems))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, WeatherController.FiveDaysForecast> {
        let cellRegistration = UICollectionView.CellRegistration<CurrentWeatherCollectionViewCell, WeatherController.FiveDaysForecast> { (cell, indexPath, fiveDaysForecast) in
            cell.temperatureLabel.text = "\(fiveDaysForecast.temperature)°"
            cell.weatherIconImage.image = fiveDaysForecast.image
            let date = self.changeDateFormat(of: fiveDaysForecast.date)
            cell.dateLabel.text = "\(date)"
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
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: weatherCollectionView){ collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
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
        applySnapShot()
    }
}

extension WeatherViewController: FiveDaysForecastDelegate {

    func notifyToUpdateFiveDaysForecast() {
        print("notifyToUpdateCurrentWeather")
//        applySnapShot()
    }
}
