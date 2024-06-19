// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let audioResponse = try? JSONDecoder().decode(AudioResponse.self, from: jsonData)

import Foundation

// MARK: - AudioResponse
struct AudioResponse: Codable {
    let audioContent: String
    let audioConfig: AudioConfig
}

// MARK: - AudioConfig
struct AudioConfig: Codable {
    let audioEncoding: String
    let speakingRate, pitch, volumeGainDB, sampleRateHertz: Int

    enum CodingKeys: String, CodingKey {
        case audioEncoding, speakingRate, pitch
        case volumeGainDB = "volumeGainDb"
        case sampleRateHertz
    }
}


/*
 {
   "audioConfig": {
     "audioEncoding": "LINEAR16",
     "effectsProfileId": [
       "handset-class-device"
     ],
     "pitch": 0,
     "speakingRate": 1
   },
   "input": {
     "text": "Movies, oh my gosh, I just just absolutely love them. They're like time machines taking you to different worlds and landscapes, and um, and I just can't get enough of it."
   },
   "voice": {
     "languageCode": "en-US",
     "name": "en-US-Journey-F"
   }
 }
 */




// MARK: - AudioRequest
struct AudioRequest: Codable, DictionaryConvertible {
    let audioConfig: AudioConfig2
    let input: Input
    let voice: Voice
}

// MARK: - AudioConfig
struct AudioConfig2: Codable {
    let audioEncoding: String
    let effectsProfileID: [String]
    let pitch, speakingRate: Double

    enum CodingKeys: String, CodingKey {
        case audioEncoding
        case effectsProfileID = "effectsProfileId"
        case pitch, speakingRate
    }
}

// MARK: - Input
struct Input: Codable {
    let text: String
}

// MARK: - Voice
struct Voice: Codable {
    let languageCode, name: String
}


/*
 {
     "audioContent":"base64 text",
     "audioConfig": {
         "audioEncoding": "LINEAR16",
         "speakingRate": 1,
         "pitch": 0,
         "volumeGainDb": 0,
         "sampleRateHertz": 24000
     }
 }
 */
