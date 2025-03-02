//
//  Item.swift
//  12Days
//
//  Created by Nicholas Rockwell on 2/26/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
