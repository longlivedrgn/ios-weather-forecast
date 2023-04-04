//
//  String+.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/04/04.
//

import Foundation

extension String {
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)!
        
        let changedDateFormatter = DateFormatter()
        changedDateFormatter.dateFormat = "MM/dd(EEEEE) HH시"
        changedDateFormatter.locale = Locale(identifier: "ko_KR")
        
        let changedDate = changedDateFormatter.string(from: date)
        return changedDate
    }
}
