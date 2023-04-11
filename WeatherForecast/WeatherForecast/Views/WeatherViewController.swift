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
    private var navigationBar = CustomNavigationBar()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureHierarchy()
        register()
        collectionViewDelegate()
    }
}

extension WeatherViewController {
    private func configureHierarchy() {
        
        weatherCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        weatherCollectionView.backgroundView = backgroundImageView
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherCollectionView)
        
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(navigationBar)
        navigationBar.makeAlertDelegate = self
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        configureRefreshControl(in: weatherCollectionView)
    }
    
    private func collectionViewDelegate() {
        
        weatherCollectionView.dataSource = self
        
        weatherViewModel.delegate = self
    }
    
    private func register() {
        
        weatherCollectionView.register(cell: FiveDaysForecastCell.self)
        weatherCollectionView.register(header: CurrentWeatherCell.self)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        
        configuration.headerMode = .supplementary
//        configuration.headerTopPadding = self.navigationBar.intrinsicContentSize.height
        
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

extension WeatherViewController: MakeAlertDelegate {
    
    func alertDelegate() {
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "변경", style: .default) { _ in
            guard let longitude = Double(alertController.textFields?[0].text ?? "") else { return }
            guard let latitude = Double(alertController.textFields?[1].text ?? "") else { return }
            self.weatherViewModel.receiveDataFromAlertController(Coordinate(longitude: longitude, latitude: latitude))
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        alertController.addTextField { textField in
            textField.placeholder = "위도"
        }
        alertController.addTextField { textField in
            textField.placeholder = "경도"
        }
        present(alertController, animated: true, completion: nil)
    }
}

extension WeatherViewController {
    
    final private class CustomNavigationBar: UINavigationBar {
        
        weak var makeAlertDelegate: MakeAlertDelegate?
        
        override init(frame: CGRect) {
            super.init(frame: .zero)
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            self.standardAppearance = appearance
            self.scrollEdgeAppearance = appearance
            
            let navigationItem = UINavigationItem()
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(navigationItemTapped))
            self.items = [navigationItem]
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc private func navigationItemTapped() {
            makeAlertDelegate?.alertDelegate()
        }
    }
}
