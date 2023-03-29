//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    private var weatherController = WeatherController()
    
    private var collectionView: UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.collectionView?.backgroundColor = .blue
        
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        return cv
    }
    
    // MARK: 1. section 생성
    private enum ForecastSection: Int {
        case main
    }
    
    // MARK: 2. datasource 선언
    private var forecastDataSource: UICollectionViewDiffableDataSource<ForecastSection, WeatherController.CurrentWeather.ID>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherController.currentWeatherDelegate = self
        
        configureCollectionView()
        configureDataSource()
        //        configureLayout()
    }
    
}

extension WeatherViewController {
    
    //    private func configureLayout() {
    //        collectionView.frame = view.bounds
    //    }
    
    // MARK: collectionView의 layout configuration 설정
    private func configureCollectionView() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.headerMode = .supplementary
            
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            
            return section
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: DiffableDataSource 설정
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, WeatherController.CurrentWeather> { cell, indexPath, currentWeather in
            
            var contentConfiguration = UIListContentConfiguration.subtitleCell()
            contentConfiguration.text = currentWeather.address
            contentConfiguration.secondaryText = currentWeather.temperatures.temperature.description
            contentConfiguration.image = currentWeather.image
            
            cell.contentConfiguration = contentConfiguration
        }
        
        forecastDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier -> UICollectionViewCell in
            
            guard let data = self.weatherController.currentWeather else {
                print("here")
                return UICollectionViewCell()
            }
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: data)
        }
        
    }
    
}

extension WeatherViewController: CurrentWeatherDelegate {
    
    func send(current: WeatherController.CurrentWeather) {
        print("viewController: \(current)")
    }
    
}

