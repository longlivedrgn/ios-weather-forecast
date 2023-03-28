//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    enum Section {
        case main
    }

    private var weatherController = WeatherController()
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, WeatherController.FiveDaysForecast>! = nil

    @IBAction func buttonTapped(_ sender: Any) {
        print(weatherController.currentWeathers?.address)
        guard let forcasts = weatherController.fiveDaysForcasts else { return print("asdf")}
        print(forcasts[0].temperature)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
}

extension WeatherViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, WeatherController.FiveDaysForecast> { cell, indexPath, fiveDaysForecast in
            var content = cell.defaultContentConfiguration()
            content.image = fiveDaysForecast.image
            content.text  = fiveDaysForecast.date
            content.secondaryText = "\(fiveDaysForecast.temperature)"
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, WeatherController.FiveDaysForecast>(collectionView: collectionView, cellProvider: { collectionView, indexPath, identifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        })
        
        guard let fiveDaysForcasts = weatherController.fiveDaysForcasts else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherController.FiveDaysForecast>()
        snapshot.appendSections([.main])
        snapshot.appendItems(fiveDaysForcasts)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
