//
//  ChatMessageView.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/19/24.
//

import SwiftUI

struct ChatMessageView: View {
    let message: ChatMessage
    
    @ObservedObject var viewModel: ChatViewModel
    @Binding var showResendConfirmation: Bool
    
    var body: some View {
        Group {
            switch message.role {
            case .assistant:
                VStack(alignment: .leading, spacing: 4.0) {
                    HStack {
                        Text(message.message)
                            .foregroundStyle(ODLColor.black900)
                            .padding(EdgeInsets(top: 16.0, leading: 12.0, bottom: 16.0, trailing: 12.0))
                            .background {
                                ODLColor.gray100
                                    .cornerRadius(16.0, corners: [.topLeft, .topRight, .bottomRight])
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .leading)
                        Spacer()
                    }
                    Text(message.created.time)
                        .font(.system(size: 11.0))
                        .foregroundStyle(ODLColor.gray500)
                }
                .padding(.leading, 20.0)
                .transition(.scale(scale: 0.4, anchor: .bottomLeading))
                .id(message.id)
            case .user:
                VStack(alignment: .trailing, spacing: 4.0) {
                    HStack {
                        Spacer()
                        Text(message.message)
                            .foregroundStyle(.white)
                            .padding(EdgeInsets(top: 16.0, leading: 12.0, bottom: 16.0, trailing: 12.0))
                            .background {
                                let cornerRadius = message.message.count < 5 ? 12.0 : 16.0
                                ODLColor.black900
                                    .cornerRadius(cornerRadius, corners: [.topLeft, .topRight, .bottomLeft])
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .trailing)
                        
                        if let didSendSuccessfully = message.didSendSuccessfully,
                           !didSendSuccessfully {
                            SystemImage.exclamationmarkCircle
                                .resizable()
                                .frame(width: 24.0, height: 24.0)
                                .foregroundStyle(ODLColor.errorRed)
                        }
                    }
                    
                    if let didSendSuccessfully = message.didSendSuccessfully,
                       !didSendSuccessfully {
                        Text("Failed to send. Tap to retry.")
                            .font(.system(size: 11.0, weight: .semibold))
                            .underline()
                            .foregroundStyle(ODLColor.errorRed)
                            .padding(.trailing, 24.0 + 6.0)
                    } else {
                        Text(message.created.time)
                            .font(.system(size: 11.0))
                            .foregroundStyle(ODLColor.gray500)
                    }
                }
                .padding(.trailing, 20.0)
                .transition(.asymmetric(insertion: .scale(scale: 0.5, anchor: .bottomTrailing),
                                        removal: .opacity))
                .id(message.id)
                .contentShape(Rectangle())
                .onTapGesture {
                    if let didSendSuccessfully = message.didSendSuccessfully,
                       !didSendSuccessfully {
                        viewModel.selectedFailedChatMessage = message
                        showResendConfirmation = true
                    }
                }
            }
        }
    }
}

#Preview {
    VStack {
        ChatMessageView(
            message: ChatMessage(
                id: UUID().uuidString,
                message: "Hi Abdigani, how can I help you today?",
                role: .assistant,
                created: Date(),
                didSendSuccessfully: nil
            ),
            viewModel: ChatViewModel(service: MockChatService()),
            showResendConfirmation: .constant(false)
        )
        ChatMessageView(
            message: ChatMessage(
                id: UUID().uuidString,
                message: "What is the status of my transaction?",
                role: .user,
                created: Date(),
                didSendSuccessfully: nil
            ),
            viewModel: ChatViewModel(service: MockChatService()),
            showResendConfirmation: .constant(false)
        )
    }
}
