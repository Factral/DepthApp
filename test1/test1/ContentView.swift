	
    //
    //  ContentView.swift
    //  test1
    //
    //  Created by Fabian Perez on 14/09/23.
    //

    import SwiftUI

    struct ContentView: View {
        
        var body: some View {

            Zstack {
                Color(.systemMINT)
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing:20){
            
                    Image("example")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(15)
                
                    HStack {
                        Text("Niagara falls")
                            .font(.title)
                            .fontWeight(.bold)

                        Spacer()

                        VStack {

                            HStack{
                                Image(systemName: "star.fill").
                                Image(systemName: "star.fill")
                                Image(systemName: "star.fill")
                                Image(systemName: "star.fill")
                                Image(systemName: "star.leadinghalf.fill")
                            }

                            Text("(Reviews 361)")
                        }
                        .foregroundColor(.yellow)
                        .font(.caption)

                    }

                    Text("come visit the falls for an experience of a lifetime")

                    HStack{
                        Spacer()
                        Image(systemName: "fork.knife")
                        Image(systemName: "binoculars.fill")
                    }
                    .foregroundColor(.gray)
                    .font(.caption)
                }
                .padding()
                .background(Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 15))
                .padding()

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

            
