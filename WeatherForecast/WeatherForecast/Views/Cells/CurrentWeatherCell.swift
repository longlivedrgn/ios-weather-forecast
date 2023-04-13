//
//  CurrentWeatherCell.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/04/05.
//

import UIKit

final class CurrentWeatherCell: UICollectionViewListCell {
    
    var currentWeather: CurrentWeatherViewModel.CurrentWeather?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        let (addressAndTemperatureText, currentTemperature) = makeTemperatureText()
        var configuration = configureAttribute(addressAndTemperatureText: addressAndTemperatureText, currentTemperatureText: currentTemperature)
        configuration.image = currentWeather?.image
        
        contentConfiguration = configuration
    }
    
    private func makeTemperatureText() -> (String, String) {
        
        guard let address = currentWeather?.address,
              let minimumTemperature = currentWeather?.temperatures.minimumTemperature.changeWeatherFormat(),
              let maximumTemperature = currentWeather?.temperatures.maximumTemperature.changeWeatherFormat(),
              let currentTemperatureText = currentWeather?.temperatures.averageTemperature.description else { return ("", "") }
        
        let addressAndTemperatureText: String = """
        \(address)
        최저 \(minimumTemperature) 최소 \(maximumTemperature)
        """
        
        return (addressAndTemperatureText, currentTemperatureText)
    }
    
    private func configureAttribute(addressAndTemperatureText: String, currentTemperatureText: String) -> UIListContentConfiguration {
        
        var configuration = UIListContentConfiguration.subtitleCell()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let addressAndTemperatureTextAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 13),
            .paragraphStyle : paragraphStyle,
        ]
        
        configuration.attributedText = NSAttributedString(string: addressAndTemperatureText,attributes: addressAndTemperatureTextAttributes)
        configuration.textProperties.color = .white
        
        let currentTemperatureTextAttribtues: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 30, weight: .semibold)
        ]
        
        configuration.secondaryAttributedText = NSAttributedString(string: currentTemperatureText,attributes: currentTemperatureTextAttribtues)
        configuration.secondaryTextProperties.color = .white
        configuration.textToSecondaryTextVerticalPadding = 10
        
        return configuration
    }
}

protocol MakeAlertDelegate: AnyObject {
    
    func alertDelegate()
}
