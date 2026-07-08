//
//  AIAssistantView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import SwiftUI
import PhotosUI

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
            headerView
            
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
                        
                        if !viewModel.suggestedProducts.isEmpty {
                            SuggestedProductsView(products: viewModel.suggestedProducts)
                        }
                        
                        if !viewModel.suggestedCategories.isEmpty {
                            SuggestedCategoriesView(categories: viewModel.suggestedCategories)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onChange(of: viewModel.messages) { _, _ in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        if let lastMessage = viewModel.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(.systemGray6))
            
            if let error = viewModel.errorMessage {
                errorBanner(error)
            }
            
            inputBar
        }
        .background(Color(.systemGroupedBackground))
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
        .photosPicker(isPresented: $showImagePicker, selection: $viewModel.selectedPhotoItem, matching: .images)
        .sheet(isPresented: $showCameraPicker) {
            CameraPicker(image: $viewModel.selectedImage, isPresented: $showCameraPicker)
        }
        .onChange(of: viewModel.selectedImage) { _, newImage in
            if let image = newImage {
                showImagePreview(image: image)
            }
        }
    }

    
    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(colors: [.appBlue, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 40, height: 40)
                    Image(systemName: "sparkles")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("AI Shopping Assistant")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("Always here to help")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if viewModel.isGuestMode && AIConfig.guestModeRestricted {
                    Label("Guest", systemImage: "person.crop.circle.badge.exclamationmark")
                        .font(.caption2.bold())
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial)
            
            Divider()
        }
    }
    
    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                Button {
                    showAttachmentOptions.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.appBlue)
                        .frame(width: 36, height: 36)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                .confirmationDialog("Add Attachment", isPresented: $showAttachmentOptions) {
                    Button("📷 Take Photo") { showCameraPicker = true }
                    Button("🖼️ Choose from Gallery") { showImagePicker = true }
                    Button("Cancel", role: .cancel) {}
                }
                
                TextField("Ask about products...", text: $inputText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
                    .disabled(viewModel.isGuestMode && AIConfig.guestModeRestricted)
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(inputText.isEmpty ? Color.gray.opacity(0.5) : Color.appBlue)
                        .clipShape(Circle())
                }
                .disabled(inputText.isEmpty || (viewModel.isGuestMode && AIConfig.guestModeRestricted))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial)
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
        
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let text = inputText
        inputText = ""
        viewModel.sendMessage(text)
    }
}

