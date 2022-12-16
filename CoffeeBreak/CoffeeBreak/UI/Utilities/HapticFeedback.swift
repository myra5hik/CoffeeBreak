//
//  HapticFeedback.swift
//  CoffeeBreak
//
//  Created by Ravi  on 12/16/22.
//

import Foundation
import SwiftUI


struct HapticFeedback {
    let button = UIImpactFeedbackGenerator(style: .rigid)
    let bigButton = UIImpactFeedbackGenerator(style: .heavy)
    let lightSelection = UIImpactFeedbackGenerator(style: .light)
    let largeSelection = UIImpactFeedbackGenerator(style: .medium)
}
  
