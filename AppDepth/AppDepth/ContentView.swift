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
        arView.session.delegate = viewModel
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

class ARViewModel: NSObject, ARSessionDelegate, ObservableObject {
    @Published var depthMap: CVPixelBuffer?
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        depthMap = frame.sceneDepth?.depthMap
    }
}