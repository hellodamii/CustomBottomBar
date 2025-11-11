//
//  ContentView.swift
//  CustomBottomBar
//
//  Created by Damilare Adekunle on 09/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var textGenerator = MLXTextGenerator()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Input Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Your Prompt")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    TextField("Type your prompt here...", text: $textGenerator.inputText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                        .disabled(textGenerator.isGenerating)
                }
                .padding(.horizontal)

                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        textGenerator.generateText()
                    }) {
                        HStack {
                            if textGenerator.isGenerating {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                            } else {
                                Image(systemName: "sparkles")
                            }
                            Text(textGenerator.isGenerating ? "Generating..." : "Generate")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(textGenerator.isGenerating ? Color.gray : Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                    }
                    .disabled(textGenerator.isGenerating || textGenerator.inputText.isEmpty)

                    Button(action: {
                        textGenerator.clear()
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                    }
                    .disabled(textGenerator.isGenerating)
                }
                .padding(.horizontal)

                // Error Message
                if let errorMessage = textGenerator.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }

                Divider()
                    .padding(.vertical, 8)

                // Output Section
                GeneratedTextOutputView(outputText: textGenerator.outputText)

                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("MLX Text Generator")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
