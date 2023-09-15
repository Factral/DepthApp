	
    //
    //  ContentView.swift
    //  test1
    //
    //  Created by Fabian Perez on 14/09/23.
    //

    import SwiftUI

    struct ContentView: View {
        
        var body: some View {
            
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                
                VStack {
                    Image("example")
                        .resizable()
                        .cornerRadius(15)
                        .aspectRatio(contentMode: .fit)
                        .padding(.all)
                    Text("Fig 1.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
            }
            
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                ContentView()
                ContentView()
                ContentView()
            }
        }
    }

            
