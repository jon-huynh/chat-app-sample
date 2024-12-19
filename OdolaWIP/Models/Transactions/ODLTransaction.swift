//
//  Transaction.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/17/24.
//

import SwiftUI

struct AllTransactions: Codable {
    let transactions: [ODLTransaction]
}

struct ODLTransaction: Codable {
    let id: String
    let title: String
    let amount: Double
    let currency: String
    let type: TransactionType
    let status: TransactionStatus
    let created: Date
    
    var timeAndStatus: String {
        if status == .pending {
            return created.time + " | " + "Pending"
        } else {
            return created.time
        }
    }
    
    static var mockTransactions: [ODLTransaction] {
        guard let url = Bundle.main.url(forResource: "mock_transactions", withExtension: "json") else {
            print("Error: mock_transactions.json not found.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try ODLDecoder().decode([String: [ODLTransaction]].self, from: data)
            return decodedData["transactions"] ?? []
        } catch {
            print("Error decoding mock transactions: \(error)")
            return []
        }
    }
}
