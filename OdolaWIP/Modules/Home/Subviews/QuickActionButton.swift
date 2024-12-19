//
//  QuickActionButton.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/19/24.
//

import SwiftUI

struct QuickActionButton: View {
    var icon: Image?
    let title: String
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center, spacing: 8.0) {
                if let icon {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16.0, height: 16.0)
                }
                Text(title)
                    .font(.system(size: 17.0, weight: .semibold))
            }
            .foregroundStyle(ODLColor.black900)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(EdgeInsets(top: 16.0, leading: 28.0, bottom: 16.0, trailing: 28.0))
            .background(ODLColor.gray100, in: RoundedRectangle(cornerRadius: 40.0))
        }
    }
}

#Preview {
    HStack {
        QuickActionButton(icon: SystemImage.plus, title: "Deposit") {}
        QuickActionButton(icon: SystemImage.arrowLeftArrowRight, title: "Transfer") {}
    }
}
