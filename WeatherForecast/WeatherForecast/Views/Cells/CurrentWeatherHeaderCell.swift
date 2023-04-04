//
//  CurrentWeatherHeaderView.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/30.
//

import UIKit

class CurrentWeatherHeaderCell: UICollectionViewListCell {
    
    var currentWeather: WeatherController.CurrentWeather?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var configuration = UIListContentConfiguration.subtitleCell()
        
        guard let address = currentWeather?.address, let minimumTemperature = currentWeather?.temperatures?.minimumTemperature, let maximumTemperature = currentWeather?.temperatures?.maximumTemperature, let currentTemperature = currentWeather?.temperatures?.currentTemperature.description else { return }
        
        let addressAndTemperatureText: String = """
        \(address)
        최저 \(minimumTemperature)° 최소 \(maximumTemperature)°
        """
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let addressAndTemperatureTextAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 13),
            .paragraphStyle : paragraphStyle
        ]
        
        configuration.attributedText = NSAttributedString(string: addressAndTemperatureText, attributes: addressAndTemperatureTextAttributes)
        
        let currentTemperatureTextAttribtues: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 30, weight: .semibold)
        ]
        
        configuration.secondaryAttributedText = NSAttributedString(string: currentTemperature, attributes: currentTemperatureTextAttribtues)
        
        configuration.textToSecondaryTextVerticalPadding = 10
        configuration.image = currentWeather?.image
        contentConfiguration = configuration
        
    }
}
