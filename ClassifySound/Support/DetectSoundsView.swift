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
var subtitle = ""
var thinking = [""]

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

    @State var currentDate = Date()
    let checkWhatTheDogHasHeard = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

 
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
            print("dog confidence = \(confidence)")
            if dogConfidence < 0.5{
                latestQuip = ""
            }                else{
               // latestQuip = ["I hear \(detected)", "I love you, oh master.", "Will you be my best friend?", "Walkies? Let's do walkies?"].randomElement() as! String
                
                if thinking.count > 0
                {
                latestQuip = thinking.last!
                }
                if thinking.count > 1{
                    thinking.dropLast()
                }
            }
        

        }
        else{
            
            if detected != "Dog" && detected != "Dog Bark" && detected != "Dog Bow Wow"  && detected != "Dog Growl"{
            
                if confidence > 0.8{
                    if let script = script[detected] {
                        thinking.append(script.randomElement()!)
                    }
            
                    //latestQuip = ""
                }
                
//            if confidence > 0.8 && dogConfidence > 0.5{
//                if let script = script[detected] {
//                    latestQuip = script.randomElement()!
//                }
////                else{
////                    latestQuip = ["I hear \(detected)", "I love you, oh master.", "Will you be my best friend?", "Walkies? Let's do walkies?"].randomElement() as! String
////                }
//            }
//            else{
//                if confidence > 0.5 {
//                    if let script = script[detected] {
//                        thinking.append(script.randomElement()!)
//                    }
//                    print( thinking)
//                }
////                    if dogConfidence > 0.5 {
////                        latestQuip = thinking
////                    }
//                }
            }
        }
//        return VStack(spacing: 0){
//                                VStack{
//                                    Text("")
//                                    Text("")
//                                    Text("")
//                                    Text("")
//                                    Text("")
//                                }
//       }
        
        return VStack(spacing: 0){
            VStack{
                Text(latestQuip)
            }
        }
   }
    
    
    //// I need to work out a way of turning off the dog detector afger the dog stops barking

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
                 //   Text(subtitle).onReceive(checkWhatTheDogHasHeard){ _  in subtitle = "I heard " + (thinking.last ?? "nothing")}
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
