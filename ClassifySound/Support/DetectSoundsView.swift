/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view for visualizing the confidence with which the system is detecting sounds
from the audio input.
*/

import Foundation
import SwiftUI

var dogConfidence = 0.0
var latestQuip = ""
var thinking = ""

///  Provides a visualization the app uses when detecting sounds.
struct DetectSoundsView: View {
    /// The runtime state that contains information about the strength of the detected sounds.
    @ObservedObject var state: AppState
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    
    @State private var showingImagePicker = true
    @State private var inputImage: UIImage?
        /// The configuration that dictates aspects of sound classification, as well as aspects of the visualization.
    @Binding var config: AppConfiguration

 
    static func cardify<T: View>(view: T) -> some View {
        let dimensions = (CGFloat(600.0), CGFloat(600.0))
        let cornerRadius = 20.0
        let color = Color.blue
        let opacity = 0.2

        return view
          .frame(width: dimensions.0,
                 height: dimensions.1)
    }
    
    static func generateMeter(detected: String, confidence: Double) -> some View{
        
        print(detected)
        
        if detected == "Dog" || detected == "Dog Bark" || detected == "Dog Bow Wow" || detected == "Dog Growl"{
                dogConfidence = confidence
            if dogConfidence < 0.5{
                latestQuip = ""
            }
        }
        else{
            
            if detected != "Dog" && detected != "Dog Bark" && detected != "Dog Bow Wow"  && detected != "Dog Growl"{
            
            if confidence > 0.9 && dogConfidence > 0.5{
                if let script = script[detected] {
                    latestQuip = script
                }
            }
            else{
                if confidence > 0.9 {
                    if let script = script[detected] {
                        thinking = script
                    }
                    print( thinking)
                }
                    if dogConfidence > 0.5 {
                        latestQuip = thinking
                    }
                }
            }
        }
        return VStack(spacing: 0){
                                VStack{
                                    Text(latestQuip)
                                }
       }
   }

static func generateDetectionsGrid(_ detections: [(SoundIdentifier, DetectionState)]) -> some View {
                return ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 600, maximum: 1500))],
                              spacing: 2) {
                        ForEach(detections, id: \.0.labelName){
                            //print($0.0.displayName)
                            
                            let confidence = $0.1.currentConfidence
                            if $0.1.currentConfidence > 0.5 {
                               
                                generateMeter(detected: $0.0.displayName, confidence: $0.1.currentConfidence)
                                
                        
                            }
                        }
                    }
                }
            }

    var body: some View {
        NavigationView {
        VStack {
            ZStack {
                VStack {
                    VideoComponent()
                    Text( latestQuip)
                    DetectSoundsView.generateDetectionsGrid(state.detectionStates)
                }.blur(radius: state.soundDetectionIsRunning ? 0.0 : 10.0)
                    .disabled(!state.soundDetectionIsRunning)
                }
        }.padding([.horizontal, .bottom])
            .navigationBarTitle("Dog Translator")
    }
}
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }

}

struct VideoComponent: UIViewControllerRepresentable {
    
    
    
    typealias UIViewControllerType =  ViewController

    
    class Coordinator : NSObject {
        var parent: VideoComponent
        
        init(_ parent:VideoComponent) {
            self.parent = parent
        }
    }
    
    func makeUIViewController(context: Context) -> ViewController {
        let videoViewController = ViewController()
        return videoViewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
    
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
