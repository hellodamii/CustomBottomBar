//
//  GeneratedTextOutputView.swift
//  CustomBottomBar
//
//  Created by Damilare Adekunle on 11/11/2025.
//

import SwiftUI

struct GeneratedTextOutputView: View {
    let outputText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Generated Output")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Spacer()

                if !outputText.isEmpty {
                    Button(action: {
                        UIPasteboard.general.string = outputText
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.doc")
                            Text("Copy")
                        }
                        .font(.caption)
                        .foregroundStyle(.blue)
                    }
                }
            }
            .padding(.horizontal)

            ScrollView {
                if outputText.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "text.bubble")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary.opacity(0.5))

                        Text("Generated text will appear here")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                } else {
                    Text(outputText)
                        .font(.body)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                        .padding(.horizontal)
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    VStack {
        GeneratedTextOutputView(outputText: "")
            .frame(height: 300)

        Divider()

        GeneratedTextOutputView(outputText: "This is a sample generated text that demonstrates how the output will look when the MLX model generates content. It can be multiple lines and will be scrollable if it gets too long.")
            .frame(height: 300)
    }
}
