//
//  TransactionStatus.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/19/24.
//

import Foundation

enum TransactionStatus: String, Codable {
    case pending
    case completed
    case failed
    case cancelled
}
