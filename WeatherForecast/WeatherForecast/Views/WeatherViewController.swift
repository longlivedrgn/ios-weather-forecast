//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    private var weatherViewModel = WeatherViewModel()
    
    // collectionView는 초기화 시, layout 설정을 해주지 않으면 초기화 불가능.
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    // MARK: 1. section 생성
    private enum ForecastSection: Int {
        case main
    }
    
    // MARK: 2. datasource 선언
    private var forecastDataSource: UICollectionViewDiffableDataSource<ForecastSection, CurrentWeatherViewModel.CurrentWeather.ID>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureCollectionView()
        configureDataSource()
        configureLayout()
    }
    
}

extension WeatherViewController {
    
    private func configureLayout() {
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .lightGray
        
        view.addSubview(collectionView)
    }
    
    // MARK: collectionView의 layout configuration 설정
    private func configureCollectionView() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
//            configuration.headerMode = .supplementary
            
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            
            return section
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: DiffableDataSource 설정
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, CurrentWeatherViewModel.CurrentWeather> { cell, indexPath, currentWeather in
            
            var contentConfiguration = UIListContentConfiguration.subtitleCell()
            contentConfiguration.text = currentWeather.address
            contentConfiguration.secondaryText = currentWeather.temperatures.temperature.description
            contentConfiguration.image = currentWeather.image
            
            cell.contentConfiguration = contentConfiguration
        }
        
        forecastDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier -> UICollectionViewCell in
            
            guard let data = self.weatherViewModel.currentWeather else {
                print("here")
                return UICollectionViewCell()
            }
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: data)
        }
        
    }
    
    private func updateSnapshot() {
        guard let currentWeather = weatherViewModel.currentWeather?.id else { return }
//                as? WeatherController.CurrentWeather.ID else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<ForecastSection, CurrentWeatherViewModel.CurrentWeather.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems([currentWeather], toSection: .main)
        forecastDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

//extension WeatherViewController: WeatherDelegate {
//
//    func sendCurrent() {
//        // header view update
//        print(weatherViewModel.currentWeather)
//        updateSnapshot()
//    }
//
//    func sendForecast() {
//        print(weatherViewModel.forecaseWeather)
//    }
//
//}

