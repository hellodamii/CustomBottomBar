//
//  MLXTextGenerator.swift
//  CustomBottomBar
//
//  Created by Damilare Adekunle on 11/11/2025.
//

import SwiftUI
import MLX
import MLXNN
import MLXRandom
import MLXLLM

@Observable
class MLXTextGenerator {
    var inputText: String = ""
    var outputText: String = ""
    var isGenerating: Bool = false
    var errorMessage: String?

    private var modelContainer: ModelContainer?

    init() {
        loadModel()
    }

    /// Load the MLX language model
    private func loadModel() {
        Task {
            do {
                // Initialize with a small model configuration
                // You can customize this based on your needs
                let modelConfiguration = ModelConfiguration.smolLM_135M_4bit
                modelContainer = try await ModelContainer(configuration: modelConfiguration)
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to load model: \(error.localizedDescription)"
                }
            }
        }
    }

    /// Generate text based on the input prompt
    func generateText() {
        guard !inputText.isEmpty else {
            errorMessage = "Please enter a prompt"
            return
        }

        guard let modelContainer = modelContainer else {
            errorMessage = "Model not loaded yet. Please wait..."
            return
        }

        Task {
            await MainActor.run {
                isGenerating = true
                outputText = ""
                errorMessage = nil
            }

            do {
                let generateParameters = GenerateParameters(
                    temperature: 0.7,
                    topP: 0.9,
                    maxTokens: 200
                )

                // Generate text using the model
                let result = try await modelContainer.perform { context in
                    try MLXLMCommon.generate(
                        prompt: inputText,
                        parameters: generateParameters,
                        context: context
                    ) { token in
                        // Stream tokens as they're generated
                        Task { @MainActor in
                            outputText += token
                        }
                        return .more
                    }
                }

                await MainActor.run {
                    isGenerating = false
                }
            } catch {
                await MainActor.run {
                    isGenerating = false
                    errorMessage = "Generation failed: \(error.localizedDescription)"
                }
            }
        }
    }

    /// Clear the input and output
    func clear() {
        inputText = ""
        outputText = ""
        errorMessage = nil
    }
}
