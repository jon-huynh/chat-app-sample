//
//  TransactionService.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/17/24.
//

import Foundation

protocol TransactionServiceProtocol {
    func getTransactions() async throws -> [ODLTransaction]
}
