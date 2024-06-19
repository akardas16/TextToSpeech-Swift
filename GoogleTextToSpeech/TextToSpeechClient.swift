//
//  TextToSpeechClient.swift
//  LearningApp
//
//  Created by Abdullah Kardaş on 19.06.2024.
//

import Foundation
import AVFAudio


class TextToSpeechClient{
    var key:String = ""
    private var player: AVAudioPlayer?
    
    init(key:String){
        self.key = key
    }
    
    func fetcAudioFromGoogle(
        text:String,
        voiceName:String = "en-US-Journey-F",
        pitch:Double = 0,
        speakingRate:Double = 1) async throws -> AudioResponse{
            
            do {
                
                //Set Up Url
                let url = "https://texttospeech.googleapis.com/v1beta1/text:synthesize?alt=json&key=\(key)"
                guard let urlPath = URLComponents(string: url) else { throw URLError(.badURL)}
                let mainUrl = urlPath.url!
                
                //Set Up request
                var request = URLRequest(url: mainUrl)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                //Set Up body
                let audioConfig = AudioConfig2(audioEncoding: "LINEAR16", effectsProfileID: [
                    "handset-class-device"
                ], pitch: 0, speakingRate: 1)
                let body = AudioRequest(audioConfig: audioConfig, input: Input(text: text), voice: Voice(languageCode: voiceName.toLanguageCode(), name: voiceName))
                request.httpBody = try JSONSerialization.data(withJSONObject: body.convertToDictionary())
                
                
                //Making network request
                let (data,resultResponse) = try await URLSession.shared.data(for: request)
                //print("******** httpResponse --> \(String(describing: httpResponse?.statusCode)) \(String(describing: String(bytes: data, encoding: .utf8)))")
                let httpResponse = resultResponse as? HTTPURLResponse
                if let statuscode = httpResponse?.statusCode, (200...299).contains(statuscode){
                    let response = try JSONDecoder().decode(AudioResponse.self, from: data)
                    return response
                }else{
                    throw String(describing: String(bytes: data, encoding: .utf8))
                }
                
                
            } catch let error  {
                throw error
            }
            
        }
    
    func fetchBase64Text(text:String,
                         voiceName:String = "en-US-Journey-F",
                         pitch:Double = 0,
                         speakingRate:Double = 1){
        Task {
            do {
                let result = try await fetcAudioFromGoogle(text: text, voiceName: voiceName, pitch: pitch, speakingRate: speakingRate)
                playAudioText(base64: result.audioContent)
                
            } catch {
                print("Error encoding user object:", error)
            }
        }
    }
    
    func playAudioText(base64:String){
        guard let mediaData = Data(base64Encoded: base64) else {
            print("Invalid Base64 string")
            return
        }
        
        let tempDir = NSTemporaryDirectory()
        let tempFileURL = URL(fileURLWithPath: tempDir).appendingPathComponent("tempMedia.mp4")

        do {
            try mediaData.write(to: tempFileURL)
        } catch {
            print("Error writing temporary file: \(error.localizedDescription)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: tempFileURL)
        } catch {
            print("couldnt play : \(error)")
        }
        player?.play()

    }
    
    func pauseSound(){
        player?.pause()
    }
    
    func stopSound(){
        player?.stop()
    }
    
}


extension String{
    func toLanguageCode() -> String{
        let array = self.components(separatedBy: "-")
        return "\(array[0])-\(array[1])"
    }
}

/*
 extension String: LocalizedError {
     public var errorDescription: String? { return self }
 }

 protocol DictionaryConvertible: Codable {
     func convertToDictionary() -> [String: Any]
 }

 extension DictionaryConvertible {
     func convertToDictionary() -> [String: Any] {
         let jsonEncoder = JSONEncoder()
         let jsonData = try! jsonEncoder.encode(self)
         do {
             return try (JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any])!
         } catch {
             print(error.localizedDescription)
             return [:]
         }
     }
 }
 */
