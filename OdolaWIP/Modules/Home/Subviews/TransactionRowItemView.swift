//
//  TransactionRowItemView.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/19/24.
//

import SwiftUI

struct TransactionRowItemView: View {
    let transaction: ODLTransaction
    let onTap: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            ZStack {
                Circle()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundStyle(ODLColor.gray100)
                transaction.type.icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16.0, height: 16.0)
                    .foregroundStyle(ODLColor.black900)
            }
            VStack(alignment: .leading, spacing: 4.0) {
                HStack(alignment: .center, spacing: .zero) {
                    Text(transaction.title)
                        .font(.system(size: 17.0, weight: .semibold))
                    Spacer()
                    Text(transaction.amount.formatted(.currency(code: "USD")))
                        .font(.system(size: 17.0, weight: .semibold))
                }
                
                Text(transaction.timeAndStatus)
                    .foregroundStyle(ODLColor.gray500)
            }
            .padding(.leading, 16.0)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    VStack {
        ForEach(ODLTransaction.mockTransactions, id: \.id) { transaction in
            TransactionRowItemView(transaction: transaction) {}
        }
    }
    .padding(.horizontal, 20.0)
}
