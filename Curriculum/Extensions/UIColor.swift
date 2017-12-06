//
//  UIColor.swift
//  Curriculum
//
//  Created by VironIT Developer on 12/6/17.
//  Copyright © 2017 VironIT Developer. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(_ r: Double,_ g: Double,_ b: Double,_ a: Double) {
        self.init(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a))
    }
}

