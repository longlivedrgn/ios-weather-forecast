//
//  CurrentWeatherCollectionViewCell.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/30.
//

import UIKit

class FiveDaysForecastCell: UICollectionViewCell {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.contentView.addSubview(weatherIconImage)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(temperatureLabel)
        contentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        weatherIconImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        weatherIconImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        weatherIconImage.heightAnchor.constraint(equalToConstant: 36).isActive = true
        weatherIconImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        temperatureLabel.rightAnchor.constraint(equalTo: weatherIconImage.leftAnchor, constant: -10).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
    }
}
