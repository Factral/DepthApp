// Created by Fabian Perez

import ARKit
import Combine
import SwiftUI
import RealityKit

class CustomARView: ARView {
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    // This is the init that we will actually use
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        subscribeToActionStream()
        setConfiguration()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func subscribeToActionStream() {
        ARManager.shared
            .actionStream
            .sink { [weak self] action in
                switch action {
                    case .removeAllAnchors:
                        self?.takeSnapshot()
                }
            }
            .store(in: &cancellables)
    }
    
    func setConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        session.run(configuration)
    }
    

    func takeSnapshot() {
        let frame: ARFrame? = session.currentFrame
        guard let depthData: CVPixelBuffer! = frame?.sceneDepth?.depthMap,
              let confidenceData: CVPixelBuffer! = frame?.sceneDepth?.confidenceMap,
              let pixelBuffer: CVPixelBuffer! = frame?.capturedImage
        else { return nil }

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)

        let depthImage = CIImage(cvPixelBuffer: depthData)
        let confidenceImage = CIImage(cvPixelBuffer: confidenceData)

        let depthCGImage = context.createCGImage(depthImage, from: depthImage.extent)
        let confidenceCGImage = context.createCGImage(confidenceImage, from: confidenceImage.extent)

        let image = UIImage(cgImage: cgImage!)
        let depthUIImage = UIImage(cgImage: depthCGImage!)
        let confidenceUIImage = UIImage(cgImage: confidenceCGImage!)

        // save photos ?
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        UIImageWriteToSavedPhotosAlbum(depthUIImage, nil, nil, nil)
        UIImageWriteToSavedPhotosAlbum(confidenceUIImage, nil, nil, nil)
    }


}
