//
//  Cost.swift
//  SimpleBudget
//
//  Created by Lezardvaleth on 2019/2/15.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit

class Cost: NSObject {
    //MARK: Properties
    var date: String
    var category: String?
    var amount: Double
    var reminder: String?
    
    init?(date: String, category: String?, amount: Double, reminder: String?) {
        guard !amount.isNaN else {
            return nil
        }
        self.date = date
        self.category = category
        self.amount = amount
        self.reminder = reminder
    }
    
}
