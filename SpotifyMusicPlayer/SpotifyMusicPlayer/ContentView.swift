//
//  ContentView.swift
//  SpotifyMusicPlayer
//
//  Created by Muhammad Osama Naeem on 10/16/21.
//

import SwiftUI

struct ContentView: View {
    var systemNamePics = ["shuffle", "backward.end.fill", "pause.circle.fill", "forward.end.fill", "repeat"]
    @StateObject var nowPlayingViewModel = NowPlayingViewModel()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common)
    @State var currentTime : Int = 0
    @State var progress = 0.00
    @State var isPlaying: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.pink, .cyan], startPoint: .top, endPoint: .bottom)
               
                VStack(alignment: .leading,spacing:0) {
                    
                    Image("album1")
                        .resizable()
                        .frame(width: 350, height: 350)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding()
                    
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Lost In Istanbul")
                                .font(.title2)
                                .foregroundColor(.white)
                                .bold()
                            
                            Text("Brianna")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        
                        
                        Spacer()
                        Image(systemName: "suit.heart.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                            
                            
                        
                    }.padding()
                   
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack(alignment: .leading) {
                            GeometryReader { proxy in
                                Rectangle()
                                    .frame(maxWidth: .infinity, maxHeight: 3)
                                    .foregroundColor(.black)
                                    .opacity(0.3)
                                    .padding()

                                Rectangle()
                                    .frame(width: (proxy.size.width - 32) * progress, height: 3)
                                    .foregroundColor(.white)
                                    .padding()
                                    .overlay(
                                        HStack(spacing: 0) {
                                            Spacer()
                                            Circle()
                                                .frame(width: 12, height: 12)
                                                .padding()
                                                .foregroundColor(.white)
                                        }

                                    )
                            }.frame(maxWidth: .infinity, maxHeight: 40)
                               
                        }
                        //.background(Color.red)
                        
                        
                        HStack(spacing: 0) {
                            Text(self.getFormattedProgressTime(totalSongDuration: self.currentTime))
                                .font(.custom("san francisco", size: 12))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text(self.getFormattedProgressTime(totalSongDuration: Int(self.nowPlayingViewModel.durationTime)))
                                .font(.custom("san francisco", size: 12))
                                .foregroundColor(.white)
                        }.padding()
                        .padding(.top, -28)
                        
                        
                        HStack {
                              ForEach(systemNamePics, id: \.self) { item in
                                  ZStack {
                                      if item == "pause.circle.fill" || item == "play.circle.fill"   {
                                          Button(action: {
                                              self.isPlaying.toggle()
                                              if self.isPlaying {
                                                  self.playAudio()
                                              }else {
                                                  self.pauseAudio()
                                              }
                                          }, label:  {
                                              Image(systemName: self.isPlaying ? "pause.circle.fill" : "play.circle.fill" )
                                                  .resizable()
                                                  .frame(width: 60, height: 60)
                                              .foregroundColor(.white)
                                          })
                                    
                                      }else if item == "backward.end.fill" {
                                          Button(action: {}, label:  {
                                              Image(systemName: item)
                                                  .resizable()
                                                  .frame(width: 30, height: 30)
                                                  .foregroundColor(.white)
                                          })
                                             
                                      }else if item == "forward.end.fill" {
                                            Button(action: {}, label:  {
                                              Image(systemName: item)
                                                  .resizable()
                                                  .frame(width: 30, height: 30)
                                                  .foregroundColor(.white)
                                            })
                                      }else {
                                            Button(action: {}, label:  {
                                              Image(systemName: item)
                                                  .resizable()
                                                  .frame(width: 20, height: 20)
                                                  .foregroundColor(.white)
                                            })
                                      }
                                      
                                  }.frame(maxWidth: .infinity)
                              }
                        }.padding(.top, 10)
                    }
                    
                    Spacer()
                       
                }
                .padding(.top, 120)
                
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                self.setupAudio()
               
            }
            .onReceive(timer) { input in
                self.getCurrentProgress()
                self.currentTime = Int(self.nowPlayingViewModel.player.currentTime)
            }
        }
    }
    
    func setupAudio() {
        self.nowPlayingViewModel.setupAudio(musicFileName: "istanbul")
    }
  
    func playAudio() {
        self.nowPlayingViewModel.playAudio()
        _ = timer.connect()
    }
    func pauseAudio() {
        self.nowPlayingViewModel.pauseAudio()
    }
    
    
    func getCurrentProgress()  {
        let progress = CGFloat(self.nowPlayingViewModel.player.currentTime / self.nowPlayingViewModel.player.duration)
        self.progress = progress
       print(progress)
    }
    
    private func getFormattedProgressTime(totalSongDuration: Int) -> String{
            let progressedAudio = Double(totalSongDuration)
            
            let seconds = Int(progressedAudio) % 60
            let minutes = (Int(progressedAudio) / 60) % 60
        
            let secondFormat = String(format: "%02d", seconds)
            return String("\(minutes):\(secondFormat)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
