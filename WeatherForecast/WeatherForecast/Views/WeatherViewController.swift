//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private let weatherViewModel = WeatherViewModel()
    private lazy var weatherCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        return collectionView
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImage")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureAttributes()
        register()
        setUp()
        collectionViewDelegate()
        addNotificationObserver()
    }
}

extension WeatherViewController {
    private func configureAttributes() {
        weatherCollectionView.backgroundView = backgroundImageView
        configureRefreshControl(in: weatherCollectionView)
    }
    
    private func setUp() {
        view.addSubview(weatherCollectionView)
    }
    
    private func collectionViewDelegate() {
        
        weatherCollectionView.dataSource = self
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(modelDidFinishSetUp(_:)), name: Notification.Name.modelDidFinishSetUp, object: nil)
    }
    
    @objc func modelDidFinishSetUp(_ notification: Notification) {
        DispatchQueue.main.async {
            self.weatherCollectionView.reloadData()
        }
    }
    
    private func register() {
        
        weatherCollectionView.register(cell: FiveDaysForecastCell.self)
        weatherCollectionView.register(header: CurrentWeatherCell.self)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        
        configuration.headerMode = .supplementary
        configuration.backgroundColor = .clear
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    private func configureRefreshControl(in collectionView: UICollectionView) {
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        
        self.weatherCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.weatherCollectionView.refreshControl?.endRefreshing()
        }
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        weatherViewModel.fiveDaysForecastWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = weatherCollectionView.dequeue(cell: FiveDaysForecastCell.self, for: indexPath)
        let fiveDaysForecasts = weatherViewModel.fiveDaysForecastWeather
        let fiveDaysForecast = fiveDaysForecasts[indexPath.item]
        cell.configure(with: fiveDaysForecast)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerCell = weatherCollectionView.dequeue(header: CurrentWeatherCell.self, for: indexPath)
            headerCell.currentWeather = weatherViewModel.currentWeather
            
            return headerCell
            
        default:
            return UICollectionReusableView()
        }
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func weatherViewModelDidFinishSetUp(_ viewModel: WeatherViewModel) {
        
        self.weatherCollectionView.reloadData()
    }
}
