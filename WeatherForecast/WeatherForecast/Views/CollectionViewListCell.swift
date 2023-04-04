//
//  CollectionViewListCell.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/04/04.
//

import UIKit

class CollectionViewListCell: UICollectionViewListCell {
    
    // ?
    var fiveDaysForecastWeather: FiveDaysForecastWeatherViewModel.FiveDaysForecast?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var configuration = UIListContentConfiguration.subtitleCell()
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
        configuration.text = currentWeather?.address
        configuration.secondaryText = currentWeather?.temperatures.temperature.description
        configuration.image = currentWeather?.image
        contentConfiguration = configuration
    }

}
