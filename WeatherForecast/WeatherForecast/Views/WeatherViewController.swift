//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private var weatherViewModel = WeatherViewModel()
    private var weatherCollectionView: UICollectionView!
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImage")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
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
        weatherCollectionView.backgroundView = backgroundImageView
        view.addSubview(weatherCollectionView)
    }
    
    private func register() {
        weatherCollectionView.register(cell: FiveDaysForecastCell.self)
        weatherCollectionView.register(header: CurrentWeatherCell.self)
    }
    
    private func collectionViewDelegate() {
        weatherCollectionView.dataSource = self
        weatherViewModel.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
        configuration.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherViewModel.fiveDaysForecastWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherCollectionView.dequeue(cell: FiveDaysForecastCell.self, for: indexPath)
        let fiveDaysForecasts = weatherViewModel.fiveDaysForecastWeather
        
        let temperature = fiveDaysForecasts[indexPath.row].temperature
        cell.temperatureLabel.text = "\(temperature)°"
        
        let date = fiveDaysForecasts[indexPath.row].date
        let transformedDate = date.changeDateFormat()
        cell.dateLabel.text = transformedDate
        
        let weatherIconImage = fiveDaysForecasts[indexPath.row].image
        cell.weatherIconImage.image = weatherIconImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
        print(#function)
        self.weatherCollectionView.reloadData()
    }
}
