//
//  CollectionViewListCell.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/04/04.
//

import UIKit

class CollectionViewListCell: UICollectionViewListCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CollectionViewHeaderCell: UICollectionViewListCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
