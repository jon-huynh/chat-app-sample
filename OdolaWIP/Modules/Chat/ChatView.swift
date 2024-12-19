//
//  ChatView.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/17/24.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ChatViewModel(service: MockChatService())
    @State private var text: String = ""
    
    @State private var showResendConfirmation: Bool = false
    
    let BOTTOM_OF_CHAT_ID: String = "bottomOfChatId"
    
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            HStack(alignment: .center, spacing: .zero) {
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 36.0, height: 36.0)
                            .foregroundStyle(ODLColor.gray100)
                        SystemImage.xmark
                            .foregroundStyle(ODLColor.black900)
                    }
                }
                .padding(.leading, 20.0)
                Spacer()
            }
            .overlay {
                Text("Odola Support")
                    .font(.system(size: 22.0, weight: .semibold))
                    .foregroundStyle(ODLColor.black900)
            }
            .padding(.vertical, 12.0)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        LazyVStack(alignment: .center, spacing: 16.0) {
                            ForEach(viewModel.sortedChatMessages, id: \.id) { message in
                                ChatMessageView(
                                    message: message,
                                    viewModel: viewModel,
                                    showResendConfirmation: $showResendConfirmation
                                )
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        if viewModel.isSendingMessage {
                            HStack(alignment: .center, spacing: .zero) {
                                TypingIndicatorView()
                                Spacer()
                            }
                            .padding(.leading, 20.0)
                            .transition(.asymmetric(insertion: .scale(scale: 0.1, anchor: .leading),
                                                    removal: .identity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        proxy.scrollTo(BOTTOM_OF_CHAT_ID, anchor: .bottom)
                                    }
                                }
                            }
                        }
                        
                        // Used to help with smoother automatic scrolling animation
                        Rectangle()
                            .frame(height: 1.0)
                            .foregroundStyle(.clear)
                            .accessibilityHidden(true)
                            .padding(.top, 24.0)
                            .id(BOTTOM_OF_CHAT_ID)
                    }
                    .padding(.vertical, 20.0)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: viewModel.allChatMessages) { oldValue, newValue in
                    // Manually handles scrolling to last message in lieu of defaultScrollAnchor
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            proxy.scrollTo(BOTTOM_OF_CHAT_ID)
                        }
                    }
                }
            }
            
            // MARK: User Input
            TextField("", text: $text, axis: .vertical)
                .lineLimit(6)
                .padding(EdgeInsets(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 50.0))
                .overlay {
                    RoundedRectangle(cornerRadius: 26.0)
                        .stroke(ODLColor.gray300, lineWidth: 1.0)
                }
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        guard !text.isEmpty else { return }
                        let chatMessage = ChatMessage(id: UUID().uuidString, message: text, role: .user, created: Date())
                        DispatchQueue.main.async {
                            text = ""
                        }
                        Task {
                            await viewModel.sendMessage(chatMessage)
                        }
                    } label: {
                        SystemImage.paperplaneFill
                            .resizable()
                            .frame(width: 16.0, height: 17.0)
                            .foregroundStyle(ODLColor.bgPrimary)
                            .padding(10.0)
                            .background(text.isEmpty ? ODLColor.gray500 : ODLColor.brand500, in: Circle())
                    }
                    .disabled(text.isEmpty)
                    .padding(EdgeInsets(top: .zero, leading: .zero, bottom: 8.0, trailing: 8.0))
                }
                .padding(EdgeInsets(top: 8.0, leading: 20.0, bottom: 8.0, trailing: 20.0))
        }
        .background(ODLColor.bgPrimary)
        .task {
            await viewModel.startChatSupport()
        }
        .confirmationDialog(
            "Resend message?",
            isPresented: $showResendConfirmation,
            titleVisibility: .visible
        ) {
            Button("Try Again") {
                if let selectedFailedChatMessage = viewModel.selectedFailedChatMessage {
                    Task {
                        await viewModel.sendMessage(selectedFailedChatMessage, isRetry: true)
                    }
                }
            }
            
            Button("Delete Message", role: .destructive) {
                if let selectedFailedChatMessage = viewModel.selectedFailedChatMessage {
                    viewModel.deleteMessage(id: selectedFailedChatMessage.id)
                }
            }
            
            Button("Cancel", role: .cancel) {
                viewModel.selectedFailedChatMessage = nil
            }
        }
    }
}

#Preview {
    ChatView()
}
