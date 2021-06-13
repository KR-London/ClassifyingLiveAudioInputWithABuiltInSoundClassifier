/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The top-level view for the app.
*/

import SwiftUI
import SoundAnalysis

/// The main view that contains the app content.
struct ContentView: View {
    /// Indicates whether to display the setup workflow.
    @State var showSetup = true

    /// A configuration for managing the characteristics of a sound classification task.
    @State var appConfig = AppConfiguration()

    /// The runtime state that contains information about the strength of the detected sounds.
    @StateObject var appState = AppState()
    
    var checkWhatTheDogHasHeard = Timer.publish(every: 5, on: .main, in: .common).autoconnect()


    var body: some View {
        ZStack {
            if showSetup {
                SetupMonitoredSoundsView(
                  querySoundOptions: { return try AppConfiguration.listAllValidSoundIdentifiers() },
                  selectedSounds: $appConfig.monitoredSounds,
                  doneAction: {
                    showSetup = false
                    appState.restartDetection(config: appConfig)
                  })
            } else {
                DetectSoundsView(state: appState,
                                 config: $appConfig
                ).onReceive(checkWhatTheDogHasHeard){_ in if dog == true { subtitle = averageThinking() }else{ subtitle = "" } }
            }
        }
    }
    
    func averageThinking() -> String {
        dog = false
        
        if let result = mostFrequent(array: thinking) {
            thinking = [""]
            print("\(result.value) thought \(result.count) times")
            return result.value
        }
        
        if let result = mostFrequent(array: hearing) {
            hearing = [""]
            print("\(result.value) heard \(result.count) times")
            return result.value
        }
        
        return ""
    }
    
    func mostFrequent<T: Hashable>(array: [T]) -> (value: T, count: Int)? {
        var nonEmptyArray = array
//
//        if array.count > 2 {
//            nonEmptyArray = array.filter{($0 == "") == false }
//        }
//
        nonEmptyArray = Array(array.dropFirst())
        let counts = nonEmptyArray.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        
        if let (value, count) = counts.max(by: { $0.1 < $1.1 }) {
            return (value, count)
        }
        
            // array was empty
        return nil
    }
    
   
    
    func getListOfSounds() throws -> [String]{
        let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
        return request.knownClassifications
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
