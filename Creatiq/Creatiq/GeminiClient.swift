import Foundation

struct GeminiClient {
    struct CaptionResult: Decodable {
        let caption: String
        let hashtags: String
    }

    struct ScriptResult: Decodable {
        let script: String
        let shootingSuggestions: String
    }

    // TODO: Replace this with real secure loading from a Secrets.plist or similar.
    // For now this will crash if you forget to implement it, so you don't ship with an empty key.
    private static var apiKey: String {
        
        return "AIzaSyBRvpI6LCJLcn6LiA7ecs4R3bsM1Qf4S4s"
    }

    static func generateCaption(topic: String,
                                details: String,
                                desiredLength: String,
                                tone: String) async throws -> CaptionResult {
        let prompt = """
        You are an expert social media caption writer for influencers.

        INPUT:
        - Topic: \(topic)
        - What the caption is about: \(details)
        - Desired length: \(desiredLength)
        - Tone: \(tone)

        OUTPUT:
        Return a JSON object with exactly these keys:
        {
          "caption": "string",
          "hashtags": "space separated hashtags string"
        }
        """

        let modelName = "models/gemini-2.0-flash"
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/\(modelName):generateContent?key=\(apiKey)")!

        struct GeminiRequest: Encodable {
            struct Content: Encodable {
                struct Part: Encodable { let text: String }
                let parts: [Part]
            }
            let contents: [Content]
        }

        let body = GeminiRequest(contents: [.init(parts: [.init(text: prompt)])])

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, _) = try await URLSession.shared.data(for: request)

        struct GeminiResponse: Decodable {
            struct Candidate: Decodable {
                struct Content: Decodable {
                    struct Part: Decodable { let text: String? }
                    let parts: [Part]
                }
                let content: Content
            }
            let candidates: [Candidate]
        }

        let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
        let text = decoded.candidates.first?.content.parts.first?.text ?? ""

        let jsonData = text.data(using: .utf8) ?? Data()
        let result = try JSONDecoder().decode(CaptionResult.self, from: jsonData)
        return result
    }

    static func generateScript(for idea: String) async throws -> ScriptResult {
        let prompt = """
        You are a content director for an influencer.

        INPUT IDEA:
        \(idea)

        OUTPUT:
        Return a JSON object with exactly these keys:
        {
          "script": "detailed script for the content, shot by shot",
          "shootingSuggestions": "shooting locations, venues, times of day and any props"
        }
        """

        let modelName = "models/gemini-2.0-flash"
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/\(modelName):generateContent?key=\(apiKey)")!

        struct GeminiRequest: Encodable {
            struct Content: Encodable {
                struct Part: Encodable { let text: String }
                let parts: [Part]
            }
            let contents: [Content]
        }

        let body = GeminiRequest(contents: [.init(parts: [.init(text: prompt)])])

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, _) = try await URLSession.shared.data(for: request)

        struct GeminiResponse: Decodable {
            struct Candidate: Decodable {
                struct Content: Decodable {
                    struct Part: Decodable { let text: String? }
                    let parts: [Part]
                }
                let content: Content
            }
            let candidates: [Candidate]
        }

        let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
        let text = decoded.candidates.first?.content.parts.first?.text ?? ""

        let jsonData = text.data(using: .utf8) ?? Data()
        let result = try JSONDecoder().decode(ScriptResult.self, from: jsonData)
        return result
    }
}
