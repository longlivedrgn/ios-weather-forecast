//
//  CollectionViewListCell.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/04/04.
//

import UIKit

class CollectionViewListCell: UICollectionViewListCell {
    
    var fiveDaysForecastWeather: FiveDaysForecastWeatherViewModel.FiveDaysForecast?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var configuration = UIListContentConfiguration.cell()
        
        configuration.text = fiveDaysForecastWeather?.date
        configuration.secondaryText = fiveDaysForecastWeather?.temperature.description
        configuration.image = fiveDaysForecastWeather?.image
        contentConfiguration = configuration
    }
}

class CollectionViewHeaderCell: UICollectionViewListCell {
    
    var currentWeather: CurrentWeatherViewModel.CurrentWeather?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var configuration = UIListContentConfiguration.subtitleCell()
        
        // MARK: Main text 설정
        guard let address = currentWeather?.address, let minimum = currentWeather?.temperatures.minimumTemperature, let maximum = currentWeather?.temperatures.maximumTemperature, let temperature = currentWeather?.temperatures.temperature.description  else { return }
        
        let mainText: String = """
        \(address)
        최저 \(minimum) 최고 \(maximum)
        """
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 13),
            // 줄간격
            .paragraphStyle : paragraphStyle
        ]
        
        configuration.attributedText = NSAttributedString(string: mainText, attributes: attributes)
        
        // MARK: secondary text 설정
        
        let secondaryAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 24, weight: .semibold),
        ]
        
        configuration.secondaryAttributedText = NSAttributedString(string: temperature, attributes: secondaryAttributes)
        
        configuration.textToSecondaryTextVerticalPadding = 10
        configuration.image = currentWeather?.image
        contentConfiguration = configuration
    }
    
}
