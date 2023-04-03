//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private let weatherViewModel = WeatherViewModel()
    
    // collectionView는 초기화 시, layout 설정을 해주지 않으면 초기화 불가능.
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    // MARK: 1. section 생성
    private enum Section: Int, CaseIterable {
        case header
        case main
    }
    
    // MARK: 2. datasource 선언
//    private var currentDataSource: UICollectionViewDiffableDataSource<Section, CurrentWeatherViewModel.CurrentWeather.ID>!
//
//    private var forecastDataSource: UICollectionViewDiffableDataSource<Section, FiveDaysForecastWeatherViewModel.FiveDaysForecast.ID>!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, UUID>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.weatherDataDelegate = self
        
        configureCollectionView()
        configureDataSource()
        configureLayout()
    }
}


extension WeatherViewController {
    
    private func configureLayout() {
        collectionView.frame = view.bounds
        
        view.addSubview(collectionView)
    }
    
    // MARK: collectionView의 layout configuration 설정
    private func configureCollectionView() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            return section
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: DiffableDataSource 설정
    private func configureDataSource() {
        
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, CurrentWeatherViewModel.CurrentWeather> { cell, indexPath, currentWeather in
            
            var contentConfiguration = UIListContentConfiguration.subtitleCell()
            contentConfiguration.text = currentWeather.address
            contentConfiguration.secondaryText = currentWeather.temperatures.temperature.description
            contentConfiguration.image = currentWeather.image
            
            cell.contentConfiguration = contentConfiguration
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, FiveDaysForecastWeatherViewModel.FiveDaysForecast> { cell, indexPath, forecast in
            
            var contentConfiguration = UIListContentConfiguration.subtitleCell()
            contentConfiguration.text = forecast.date
            contentConfiguration.secondaryText = forecast.temperature.description
            contentConfiguration.image = forecast.image
            
            cell.contentConfiguration = contentConfiguration
        }
        
        let header = UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            // cell 등록
        }
        
//        forecastDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier -> UICollectionViewCell in
//
//            let forecast = self.weatherViewModel.forecast(with: itemIdentifier)
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: forecast)
//        }
//
//        currentDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier -> UICollectionViewCell in
//
//            guard let data = self.weatherViewModel.currentWeather else {
//                return UICollectionViewCell()
//            }
//
//            return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: data)
//        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, UUID>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: UUID) -> UICollectionViewCell? in
            
            guard let forecast = self.weatherViewModel.forecast(with: itemIdentifier) else {
                return UICollectionViewCell()
            }
            guard let data = self.weatherViewModel.currentWeather else {
                return UICollectionViewCell()
            }
            
            switch indexPath.section {
            case 0:
                print("0")
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: data)
            case 1:
                print("1")
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: forecast)
            default:
                return UICollectionViewCell()
            }
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: forecast)
        }
    }
    
//    private func updateForecastSnapshot() {
//        let forecast = weatherViewModel.fiveDaysForecastWeather.map { $0.id }
//        
//        var forecastSnapshot = NSDiffableDataSourceSnapshot<Section, FiveDaysForecastWeatherViewModel.FiveDaysForecast.ID>()
//        forecastSnapshot.appendSections([.main])
//        forecastSnapshot.appendItems(forecast, toSection: .main)
//        forecastDataSource.apply(forecastSnapshot, animatingDifferences: true)
//    }
    
//    private func updateCurrentSnapshot() {
//        guard let currentWeather = weatherViewModel.currentWeather?.id else { return }
//
//        var currentSnapshot = NSDiffableDataSourceSnapshot<Section, CurrentWeatherViewModel.CurrentWeather.ID>()
//        currentSnapshot.appendSections([.header])
//        currentSnapshot.appendItems([currentWeather], toSection: .header)
//        currentDataSource.apply(currentSnapshot, animatingDifferences: true)
//    }
    
    private func setupSnapshot() {
        let forecast = weatherViewModel.fiveDaysForecastWeather.map { $0.id }
        guard let currentWeather = weatherViewModel.currentWeather?.id else { return }
        
        var snapshot1 = NSDiffableDataSourceSectionSnapshot<UUID>()
        snapshot1.append(forecast)
        var snapshot2 = NSDiffableDataSourceSectionSnapshot<UUID>()
        snapshot2.append([currentWeather])
        
        dataSource.apply(snapshot1, to: .main)
        dataSource.apply(snapshot2, to: .header)
//        snapshot.appendSections([.main, .header])
//        snapshot.appendItems([currentWeather], toSection: .header)
//        snapshot.appendItems(forecast, toSection: .main)
//        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension WeatherViewController: WeatherDataDelegate {
    func sendCurrentWeather() {
        print("viewController: sendCurrentWeather")
//        updateForecastSnapshot()
//        updateCurrentSnapshot()
        setupSnapshot()
    }
    
    func sendForecast() {
        print("viewController: sendForecast")
        setupSnapshot()
    }
    
}

