import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @StateObject var viewModel = ARViewModel()
    
    var body: some View {
        ARViewContainer(viewModel: viewModel).edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        viewModel.setupARSession()
        arView.debugOptions.insert(.showWorldOrigin)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
            if let depthMap = viewModel.depthMap {
            // Create a CIImage from the depth map
            let depthMapImage = CIImage(cvPixelBuffer: depthMap)
            
            // Create a UIImageView to display the depth map
            let depthMapImageView = UIImageView(image: UIImage(ciImage: depthMapImage))
            depthMapImageView.contentMode = .scaleAspectFit
            
            // Add the UIImageView to the ARView
            uiView.addSubview(depthMapImageView)
            depthMapImageView.frame = uiView.bounds
        }
    }
}

class ARViewModel: NSObject, ARSessionDelegate, ObservableObject {
    @Published var depthMap: CVPixelBuffer?
    var arSession: ARSession?

    func setupARSession() {
        arSession = ARSession()
        arSession?.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = .sceneDepth
        arSession?.run(configuration)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        depthMap = frame.sceneDepth?.depthMap
        
    }
}
