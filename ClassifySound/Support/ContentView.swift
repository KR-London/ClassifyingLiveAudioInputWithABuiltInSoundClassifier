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
//            appConfig.monitoredSounds =
//                appConfig.inferenceWindowSize = 0.5
//                appConfig.overlapFactor = 1
//              a
                
                
                
         //   appConfig.monitoredSounds = getListOfSounds()
            
                DetectSoundsView(state: appState,
                                 config: $appConfig
                )
    }
        }
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
