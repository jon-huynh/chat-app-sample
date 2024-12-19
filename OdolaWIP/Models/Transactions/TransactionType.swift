//
//  TransactionType.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/19/24.
//

import SwiftUI

enum TransactionType: String, Codable {
    case deposit
    case withdrawal
    case purchase
    case transfer
    
    var icon: Image {
        switch self {
        case .deposit:
            return SystemImage.plus
        case .withdrawal:
            return SystemImage.minus
        case .purchase:
            return SystemImage.creditcardFill
        case .transfer:
            return SystemImage.arrowLeftArrowRight
        }
    }
}
