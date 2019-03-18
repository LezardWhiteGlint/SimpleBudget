//
//  ChartDateValueFormatter.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/3/15.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import Foundation
import Charts


class ChartDateValueFormatter:NSObject,IAxisValueFormatter {
    let dateFormatter = DateFormatter()
    
    override init(){
        super.init()
//        dateFormatter.dateFormat = "YYYY-MM"
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
        
}
