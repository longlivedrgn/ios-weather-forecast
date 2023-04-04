//
//  CurrentWeatherHeaderView.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/30.
//

import UIKit

class CurrentWeatherHeaderView: UICollectionReusableView {
    
    var weatherIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var CurrentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
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
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setUp() {
        addSubview(weatherIconImage)
        addSubview(addressLabel)
        addSubview(CurrentTemperatureLabel)
        addSubview(minimumMaximumTemperatureLabel)
        
        self.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        weatherIconImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        weatherIconImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        weatherIconImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: weatherIconImage.rightAnchor, constant: 5).isActive = true

        
        minimumMaximumTemperatureLabel.leftAnchor.constraint(equalTo: weatherIconImage.rightAnchor, constant: 5).isActive = true
        minimumMaximumTemperatureLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10).isActive = true
        
        CurrentTemperatureLabel.leftAnchor.constraint(equalTo: weatherIconImage.rightAnchor, constant: 10).isActive = true
        CurrentTemperatureLabel.topAnchor.constraint(equalTo: minimumMaximumTemperatureLabel.bottomAnchor, constant: 10).isActive = true
        
    }
}
