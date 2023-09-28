// Created by Fabian Perez

import ARKit
import Combine
import SwiftUI
import RealityKit
import CryptoKit
import Foundation


class CustomARView: ARView {
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        subscribeToActionStream()
        setConfiguration()
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func subscribeToActionStream() {
        ARManager.shared
            .actionStream
            .sink { [weak self] action in
                switch action {
                    case .takeSnapshot:
                        self?.takeSnapshot()
                }
            }
            .store(in: &cancellables)
    }
    
    func setConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = [.sceneDepth,.smoothedSceneDepth]
        session.run(configuration)
    }
    

    func takeSnapshot() {
        let frame: ARFrame? = session.currentFrame
        guard let depthData: CVPixelBuffer = frame?.smoothedSceneDepth?.depthMap,
              let confidenceData: CVPixelBuffer = frame?.sceneDepth?.confidenceMap,
              let pixelBuffer: CVPixelBuffer = frame?.capturedImage
        else { return }
        
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
        
        // save photos
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        UIImageWriteToSavedPhotosAlbum(depthUIImage, nil, nil, nil)
        UIImageWriteToSavedPhotosAlbum(confidenceUIImage, nil, nil, nil)
        
        
        // app folder creation
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let directory = documentDirectoryURL.appendingPathComponent("depth data")
        
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory. \(error)")
        }
        
        // file saving
        let str = "Super long string here" //random string for test
        let framePath = directory.appendingPathComponent("testeo.txt")
        do {
            try str.write(to: framePath, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing to file. \(error)")
        }


        
    }
    

/*
    private func convert(frame: CVPixelBuffer) -> PngEncoder {
        assert(CVPixelBufferGetPixelFormatType(frame) == kCVPixelFormatType_DepthFloat32)
        let height = CVPixelBufferGetHeight(frame)
        let width = CVPixelBufferGetWidth(frame)
        CVPixelBufferLockBaseAddress(frame, CVPixelBufferLockFlags.readOnly)
        let inBase = CVPixelBufferGetBaseAddress(frame)
        let inPixelData = inBase!.assumingMemoryBound(to: Float32.self)
        
        let out = PngEncoder.init(depth: inPixelData, width: Int32(width), height: Int32(height))!
        CVPixelBufferUnlockBaseAddress(frame, CVPixelBufferLockFlags(rawValue: 0))
        return out
    }
 
  idk, el import de PngEncoder desde objective c hacia swift no esta funcionando, maybe una configuracion mala en xcode
   
  la idea es usar el pngencoder para obtener directamente un png con valores en metros directamente por pixel
  
 no hice commit pq se asociaria su cuenta, si quiere puede hacer commit (ya tiene permisos) o me pasa el codigo por discord y yo lo subo al repo
 */
    


}
