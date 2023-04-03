//
//  ForecastWeatherContentView.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/04/03.
//

import UIKit

class ForecastWeatherContentView: UIView, UIContentView {
    
    var weatherIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var currentConfiguration: ForecastWeatherContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            print("happy")
        }
    }
    
    init(configuration: ForecastWeatherContentConfiguration) {
        super.init(frame: .zero)
        setUp()
        apply(configuartion: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubview(weatherIconImage)
        addSubview(dateLabel)
        addSubview(temperatureLabel)
        
        weatherIconImage.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor, constant: -10).isActive = true
        weatherIconImage.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor).isActive = true
        weatherIconImage.heightAnchor.constraint(equalToConstant: 36).isActive = true
        weatherIconImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        temperatureLabel.rightAnchor.constraint(equalTo: weatherIconImage.leftAnchor, constant: -10).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20).isActive = true
    }
    
    private func apply(configuration: ForecastWeatherContentConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        
        // 여기서 이제 변경해주기!
    }
}
