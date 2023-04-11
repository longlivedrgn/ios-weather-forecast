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
    
    lazy var weatherNavigationBar = WeatherNavigationBar()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureHierarchy()
        register()
        collectionViewDelegate()
    }
}

extension WeatherViewController {
    private func configureHierarchy() {
//        let frame = CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height)]
        weatherCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        weatherCollectionView.backgroundView = backgroundImageView
        configureRefreshControl(in: weatherCollectionView)
        view.addSubview(weatherNavigationBar)
//        view.addSubview(weatherCollectionView)
    }
    
    private func collectionViewDelegate() {
        
        weatherCollectionView.dataSource = self
        weatherViewModel.delegate = self
    }
    
    private func register() {
        
        weatherCollectionView.register(cell: FiveDaysForecastCell.self)
        weatherCollectionView.register(header: CurrentWeatherHeaderView.self)
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
    
    @objc func handleRefreshControl() {
        
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
        
        let temperature = fiveDaysForecasts[indexPath.row].temperature
        let temperatureText = String(format: "%.1f", temperature)
        cell.temperatureLabel.text = "\(temperatureText)°"
        
        let date = fiveDaysForecasts[indexPath.row].date
        let transformedDate = date.changeDateFormat()
        cell.dateLabel.text = transformedDate
        
        let weatherIconImage = fiveDaysForecasts[indexPath.row].image
        cell.weatherIconImage.image = weatherIconImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let currentWeather = weatherViewModel.currentWeather
            
            guard let headerView = weatherCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CurrentWeatherHeaderView", for: indexPath) as? CurrentWeatherHeaderView else {
                return UICollectionReusableView()
            }
            headerView.delegate = self
            headerView.configure(currentWeather: currentWeather)
            
            return headerView
            
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

extension WeatherViewController: CurrentWeatherHeaderViewDelegate {
    func currentWeatherHeaderViewButtonTapped(_ headerView: CurrentWeatherHeaderView) {
        
        // 함수로 빼기!
        let alertTitle = "위치 변경"
        let alertMessage = "날씨를 받아올 위치의 위도와 경도를 입력해주세요."
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "위도"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "경도"
        }
        
        let confirmActionTitle = "변경"
        let confirmAction = UIAlertAction(title: confirmActionTitle, style: .default) { _ in
            // 에러 처리하기
            let latitude = Double(alert.textFields?[0].text ?? "0.0") ?? 0.0
            let longitude = Double(alert.textFields?[1].text ?? "0.0") ?? 0.0
            
            let location = CLLocation(latitude: latitude, longitude: longitude)
        }
        
        let cancelActionTitle = "취소"
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
}

extension WeatherViewController {
    
    class WeatherNavigationBar: UINavigationBar {
        var weatherNavigationItem: UINavigationItem = {
            let navigationItem = UINavigationItem()
            navigationItem.title = "WeatherController"
            return navigationItem
        }()
        
        var changeLocationButton: UIBarButtonItem = {
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: #selector(changeLocationButtonTapped))
            return barButtonItem
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUpUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        private func setUpUI() {
            var statusBarHeight: CGFloat = 0
            statusBarHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
            self.frame = CGRect(x: 0, y: statusBarHeight, width: view.frame.width, height: statusBarHeight)
            weatherNavigationItem.rightBarButtonItem = changeLocationButton
            self.setItems([weatherNavigationItem], animated: true)
        }
        
        @objc func changeLocationButtonTapped() {
            print(#function)
        }
    }
    
}
