//
//  TypingIndicatorView.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/19/24.
//

import SwiftUI

struct TypingIndicatorView: View {
    @State private var count: Int = 0
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(alignment: .center, spacing: 8.0) {
            Group {
                Circle()
                    .foregroundStyle(ODLColor.gray500)
                    .offset(y: count == 1 ? -4.0 : .zero)
                Circle()
                    .foregroundStyle(ODLColor.gray500)
                    .offset(y: count == 2 ? -4.0 : .zero)
                Circle()
                    .foregroundStyle(ODLColor.gray500)
                    .offset(y: count == 3 ? -4.0 : .zero)
            }
            .frame(width: 8.0, height: 8.0)
        }
        .padding(12.0)
        .background {
            RoundedRectangle(cornerRadius: 12.0)
                .foregroundStyle(ODLColor.gray100)
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.easeIn(duration: 0.2)) {
                count = count == 3 ? 0 : count + 1
            }
        })
    }
}
#Preview {
    TypingIndicatorView()
}
