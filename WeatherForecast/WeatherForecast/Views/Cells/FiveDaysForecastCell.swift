//
//  FiveDaysForecastCell.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/04/05.
//

import UIKit

class FiveDaysForecastCell: UICollectionViewCell {
    
    var weatherIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
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
        
        weatherIconImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        weatherIconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        weatherIconImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        weatherIconImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        temperatureLabel.rightAnchor.constraint(equalTo: weatherIconImage.leftAnchor, constant: -10).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

