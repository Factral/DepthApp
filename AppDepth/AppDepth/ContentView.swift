import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @StateObject var viewModel = ARViewModel()
    @State var arView: ARView?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(viewModel: viewModel,  arView: $arView).edgesIgnoringSafeArea(.all)

            Button {
                
                print("button pressed")
                arView?.takeSnapshot()
                
            }  label: {
                if #available(iOS 15.0, *) {
                    Image(systemName: "camera")
                        .frame(width:60, height:60)
                        .font(.title)
                        .background(.white.opacity(0.75))
                        .cornerRadius(30)
                        .padding()
                } else {
                    // Fallback on earlier versions
                }
            }
        }

    }
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: ARViewModel
    @Binding var arView: ARView?

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        viewModel.setupARSession()
        arView.debugOptions.insert(.showWorldOrigin)
        self.arView = arView
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
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


extension ARView {
    func takeSnapshot() {
        self.snapshot(saveToHDR: false) { (image) in
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
    }
}
