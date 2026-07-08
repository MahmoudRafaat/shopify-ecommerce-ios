//
//  AIAssistantView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//


//
//  AIAssistantView.swift
//  shopify-ecommerce-ios
//

import SwiftUI

struct AIAssistantView: View {
    @Environment(HomeCoordinator.self) var coordinator
    @State private var viewModel: AIAssistantViewModel
    @State private var inputText = ""
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var showAttachmentOptions = false
    
    init(viewModel: AIAssistantViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }
                        
                        if viewModel.isLoading {
                            TypingIndicatorView()
                        }
                        
                        // Suggested Products
                        if !viewModel.suggestedProducts.isEmpty {
                            SuggestedProductsView(products: viewModel.suggestedProducts)
                        }
                        
                        // Suggested Categories
                        if !viewModel.suggestedCategories.isEmpty {
                            SuggestedCategoriesView(categories: viewModel.suggestedCategories)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onChange(of: viewModel.messages) { _, _ in
                    withAnimation {
                        if let lastMessage = viewModel.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(.systemGray6))
            
            // Error Message
            if let error = viewModel.errorMessage {
                errorBanner(error)
            }
            
            // Input Bar
            inputBar
        }
        .navigationTitle("AI Assistant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { viewModel.clearConversation() }) {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { viewModel.getOverallSuggestions() }) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.blue)
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.selectedImage, isPresented: $showImagePicker)
        }
        .sheet(isPresented: $showCameraPicker) {
            CameraPicker(image: $viewModel.selectedImage, isPresented: $showCameraPicker)
        }
        .onChange(of: viewModel.selectedImage) { _, newImage in
            if let image = newImage {
                // Show confirmation dialog before sending
                showImagePreview(image: image)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "brain")
                    .font(.title2)
                    .foregroundStyle(.blue)
                
                Text("AI Shopping Assistant")
                    .font(.headline)
                
                Spacer()
                
                if viewModel.isGuestMode && AIConfig.guestModeRestricted {
                    Label("Guest", systemImage: "person.crop.circle.badge.exclamationmark")
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            .padding()
            .background(Color.white)
            
            Divider()
        }
    }
    
    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // Attachment Button
                Button {
                    showAttachmentOptions.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                .confirmationDialog("Add Attachment", isPresented: $showAttachmentOptions) {
                    Button("📷 Take Photo") { showCameraPicker = true }
                    Button("🖼️ Choose from Gallery") { showImagePicker = true }
                    Button("Cancel", role: .cancel) {}
                }
                
                // Text Input
                TextField("Ask about products...", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .disabled(viewModel.isGuestMode && AIConfig.guestModeRestricted)
                
                // Voice Input Button
                Button {
                    // Voice input would be implemented here
                    // For now, just show a placeholder
                } label: {
                    Image(systemName: "mic.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                .disabled(viewModel.isGuestMode && AIConfig.guestModeRestricted)
                
                // Send Button
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(inputText.isEmpty ? .gray : .blue)
                }
                .disabled(inputText.isEmpty || (viewModel.isGuestMode && AIConfig.guestModeRestricted))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
        }
    }
    
    private func errorBanner(_ error: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.white)
            Text(error)
                .font(.caption)
                .foregroundStyle(.white)
            Spacer()
            Button {
                viewModel.errorMessage = nil
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding()
        .background(Color.red)
        .transition(.move(edge: .top))
    }
    
    private func showImagePreview(image: UIImage) {
        // Show a confirmation dialog with image preview
        // Implementation would go here
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let text = inputText
        inputText = ""
        viewModel.sendMessage(text)
    }
}

// MARK: - Supporting Views

struct MessageBubbleView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                // Message Text
                Text(message.content)
                    .font(.body)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color(.systemGray5))
                    .foregroundStyle(message.isUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Attachments
                if !message.attachments.isEmpty {
                    ForEach(message.attachments) { attachment in
                        if attachment.type == .image, let image = UIImage(data: attachment.data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200, maxHeight: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                
                // Timestamp
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.gray)
                    .padding(message.isUser ? .trailing : .leading, 4)
            }
            
            if !message.isUser {
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}

struct TypingIndicatorView: View {
    @State private var animationOffset = 0.0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color(.systemGray4))
                            .frame(width: 8, height: 8)
                            .offset(y: animationOffset)
                            .animation(
                                .easeInOut(duration: 0.5)
                                .repeatForever()
                                .delay(Double(index) * 0.15),
                                value: animationOffset
                            )
                    }
                }
                .padding(12)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            Spacer()
        }
        .padding(.vertical, 4)
        .onAppear {
            animationOffset = -4
        }
    }
}

struct SuggestedProductsView: View {
    let products: [Product]
    @Environment(HomeCoordinator.self) var coordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🛍️ Suggested Products")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(products) { product in
                        Button {
                            coordinator.goToProductDetail(id: product.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                CachedImageLoader(
                                    urlString: product.image,
                                    width: 80,
                                    height: 80
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Text(product.name)
                                    .font(.caption)
                                    .lineLimit(1)
                                
                                Text("$\(product.price, specifier: "%.2f")")
                                    .font(.caption.bold())
                            }
                            .frame(width: 100)
                            .padding(8)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 2)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

struct SuggestedCategoriesView: View {
    let categories: [Category]
    @Environment(HomeCoordinator.self) var coordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("📂 Suggested Categories")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories) { category in
                        Button {
                            coordinator.goToCategoriesScreen(id: category.id)
                        } label: {
                            HStack {
                                CachedImageLoader(
                                    urlString: category.imageName,
                                    width: 30,
                                    height: 30
                                )
                                .clipShape(Circle())
                                
                                Text(category.title)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}