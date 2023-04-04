//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private let weatherViewModel = WeatherViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        
        // cell 등록
        collectionView.register(CollectionViewListCell.self, forCellWithReuseIdentifier: "\(CollectionViewListCell.self)")
        // header 등록
        collectionView.register(CollectionViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(CollectionViewHeaderCell.self)")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.weatherDataDelegate = self
        collectionView.dataSource = self
//        configureDataSource()
    }
}


extension WeatherViewController {
    
    // MARK: collectionView의 layout configuration 설정
    private func createLayout() ->  UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.headerMode = .supplementary
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            return section
        }
        
        return layout
    }
}

extension WeatherViewController: WeatherDataDelegate {
    func sendCurrentWeather() {
        print("viewController: sendCurrentWeather")
    }
    
    func sendForecast() {
        print("viewController: sendForecast")
    }
    
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return weatherViewModel.fiveDaysForecastWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CollectionViewListCell.self)", for: indexPath) as! CollectionViewListCell
       
        var contentConfiguration = UIListContentConfiguration.subtitleCell()
        contentConfiguration.text = weatherViewModel.fiveDaysForecastWeather[indexPath.row].date
        contentConfiguration.secondaryText = weatherViewModel.fiveDaysForecastWeather[indexPath.row].temperature.description
        contentConfiguration.image = weatherViewModel.fiveDaysForecastWeather[indexPath.row].image
        
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(CollectionViewHeaderCell.self)", for: indexPath) as! CollectionViewHeaderCell

            var contentConfiguration = UIListContentConfiguration.subtitleCell()
            contentConfiguration.text = "Header? 성공?"
            header.contentConfiguration = contentConfiguration
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
