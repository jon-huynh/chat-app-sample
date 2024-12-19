//
//  HomeView.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/16/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel(repository: TransactionRepository(service: MockTransactionService()))
    @State private var showChatSupport: Bool = false
    @State private var showChatUnavailableAlert: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                VStack(spacing: 24.0) {
                    if !viewModel.isNetworkAvailable {
                        NetworkUnavailableIndicatorView()
                    }
                    
                    HStack(alignment: .center, spacing: .zero) {
                        Text("Welcome back, Abdigani")
                            .font(.system(size: 22.0, weight: .semibold))
                        Spacer()
                        SystemImage.questionmarkBubbleFill
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28.0, height: 28.0)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if viewModel.isNetworkAvailable {
                                    showChatSupport = true
                                } else {
                                    showChatUnavailableAlert = true
                                }
                            }
                    }
                    .foregroundStyle(ODLColor.black900)
                    
                    // MARK: Balance + Quick Actions
                    VStack(alignment: .center, spacing: .zero) {
                        VStack(alignment: .leading, spacing: 16.0) {
                            Text("Balance")
                            Text("$1234.56")
                                .font(.system(size: 34.0, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(alignment: .center, spacing: 20.0) {
                            QuickActionButton(icon: SystemImage.plus, title: "Deposit") {}
                            QuickActionButton(icon: SystemImage.arrowLeftArrowRight, title: "Transfer") {}
                        }
                        .padding(.top, 36.0)
                    }
                    .padding(EdgeInsets(top: 28.0, leading: 20.0, bottom: 28.0, trailing: 20.0))
                    .background {
                        Color.white
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            .shadow(color: ODLColor.gray500.opacity(0.25), radius: 4, x: 0.0, y: 1.0)
                    }
                    .background {
                        HStack {
                            Circle()
                                .frame(width: 160.0, height: 160.0)
                                .foregroundStyle(ODLColor.brand500.opacity(0.5))
                                .blur(radius: 80.0)
                            Circle()
                                .frame(width: 160.0, height: 160.0)
                                .foregroundStyle(.yellow.opacity(0.5))
                                .blur(radius: 80.0)
                        }
                    }
                }
                .padding(EdgeInsets(top: 20.0, leading: 20.0, bottom: .zero, trailing: 20.0))
                
                
                // MARK: Transactions List
                VStack(alignment: .leading, spacing: 20.0) {
                    if viewModel.isLoadingTransactions {
                        VStack {
                            ProgressView()
                                .controlSize(.extraLarge)
                                .padding(.top, 40.0)
                            Spacer()
                        }
                    } else {
                        ForEach(viewModel.sortedDates, id: \.self) { date in
                            Section {
                                if let transactionsForDate = viewModel.groupedTransactions[date] {
                                    ForEach(transactionsForDate, id: \.id) { transaction in
                                        TransactionRowItemView(transaction: transaction) {}
                                    }
                                }
                            } header: {
                                Text(date.uppercased())
                                    .fontWeight(.semibold)
                                    .foregroundStyle(ODLColor.gray500)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20.0)
                .padding(.top, 32.0)
            }
        }
        .task {
            await viewModel.getTransactions()
        }
        .fullScreenCover(isPresented: $showChatSupport, content: {
            ChatView()
        })
        .alert(isPresented: $showChatUnavailableAlert) {
            Alert(
                title: Text("Chat Unavailable"),
                message: Text("You are currently offline. Please connect to cellular data or Wi-Fi."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    HomeView()
}
