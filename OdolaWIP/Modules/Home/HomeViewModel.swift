//
//  HomeViewModel.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/17/24.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var isLoadingTransactions: Bool = false
    @Published var allTransactions: [ODLTransaction] = []
    @Published var isNetworkAvailable: Bool = true
    
    private let repository: TransactionRepository
    private var networkMonitor = NetworkMonitor.shared
    
    init(repository: TransactionRepository) {
        self.repository = repository
        networkMonitor.startMonitoring { [weak self] isConnected in
            DispatchQueue.main.async {
                withAnimation {
                    self?.isNetworkAvailable = isConnected
                }
            }
        }
    }
    
    // MARK: View
    var groupedTransactions: [String: [ODLTransaction]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd"
        
        let groups = Dictionary(grouping: allTransactions, by: { formatter.string(from: $0.created) })
        
        var sortedGroups: [String: [ODLTransaction]] = [:]
        for (key, value) in groups {
            sortedGroups[key] = value.sorted { $0.created > $1.created }
        }
        
        return sortedGroups
    }
    
    var sortedDates: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd"
        
        return groupedTransactions.keys.sorted {
            // Convert the formatted string back to Date for comparison
            if let date1 = formatter.date(from: $0), let date2 = formatter.date(from: $1) {
                return date1 > date2
            }
            return false
        }
    }
    
    // MARK: Functions
    func getTransactions() async {
        do {
            defer {
                withAnimation {
                    self.isLoadingTransactions = false
                }
            }
            
            withAnimation {
                self.isLoadingTransactions = true
            }
            
            self.allTransactions = try await repository.getTransactions(networkAvailable: isNetworkAvailable)
        } catch {
            print("Failed to get transactions data", error)
        }
    }
}
