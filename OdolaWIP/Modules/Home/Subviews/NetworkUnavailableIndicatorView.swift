//
//  NetworkUnavailableIndicatorView.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/19/24.
//

import SwiftUI

struct NetworkUnavailableIndicatorView: View {
    var body: some View {
        HStack(alignment: .center) {
            Text("You are offline".uppercased())
                .font(.system(size: 13.0, weight: .semibold))
            SystemImage.wifiSlash
        }
        .foregroundStyle(ODLColor.gray500)
    }
}

#Preview {
    NetworkUnavailableIndicatorView()
}
