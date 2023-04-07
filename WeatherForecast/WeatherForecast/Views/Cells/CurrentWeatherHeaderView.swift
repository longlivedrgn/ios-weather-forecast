//
//  CurrentWeatherCell.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/04/05.
//

import UIKit

final class CurrentWeatherHeaderView: UICollectionReusableView {
    
    var currentWeather: CurrentWeatherViewModel.CurrentWeather?
    
    var weatherIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var changeLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyinngglass"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var minimumMaximumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHeaderView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpHeaderView() {
        addSubview(weatherIconImage)
        addSubview(addressLabel)
        addSubview(currentTemperatureLabel)
        addSubview(minimumMaximumTemperatureLabel)
    }
    
    private func configureLayout() {
        
        let heightConstrinat = self.heightAnchor.constraint(equalToConstant: 105)
        heightConstrinat.isActive = true
        heightConstrinat.priority = .defaultHigh
        
        weatherIconImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        weatherIconImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        weatherIconImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: weatherIconImage.rightAnchor, constant: 5).isActive = true
        
        minimumMaximumTemperatureLabel.leftAnchor.constraint(equalTo: weatherIconImage.rightAnchor, constant: 5).isActive = true
        minimumMaximumTemperatureLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        
        currentTemperatureLabel.leftAnchor.constraint(equalTo: weatherIconImage.rightAnchor, constant: 10).isActive = true
        currentTemperatureLabel.topAnchor.constraint(equalTo: minimumMaximumTemperatureLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    func configure(currentWeather: CurrentWeatherViewModel.CurrentWeather?) {
        
        guard let address = currentWeather?.address,
              let minimumTemperature = currentWeather?.temperatures.minimumTemperature,
              let maximumTemperature = currentWeather?.temperatures.maximumTemperature,
              let currentTemperature = currentWeather?.temperatures.averageTemperature
        else { return }
        
        let minimumTemperatureText = String(format: "%.1f", minimumTemperature)
        let maximumTemperatureText = String(format: "%.1f", maximumTemperature)
        let currentTemperatureValue = String(format: "%.1f", currentTemperature)
        
        addressLabel.text = address
        weatherIconImage.image = currentWeather?.image
        currentTemperatureLabel.text = "\(currentTemperatureValue)°"
        minimumMaximumTemperatureLabel.text = "최저 \(minimumTemperature) 최고 \(maximumTemperature)"
    }
}
