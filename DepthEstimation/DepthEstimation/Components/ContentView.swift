// Created by Fabian Perez

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    
    var body: some View {
        CustomARViewRepresentable()
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                Button {
                    print("button pressed")
                    ARManager.shared.actionStream.send(.takeSnapshot)
                } label: {
                    Image(systemName: "camera")
                        .frame(width:50, height:50)
                        .scaledToFit()
                        .font(.title)
                        .background(.regularMaterial)
                        .cornerRadius(20)
                        .padding()
                }
            }
            
    }
}
