import SwiftUI
import AVKit

struct LaunchScreenView: View {
    var body: some View {
        VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "intro video", withExtension: "mov")!)) {
        }
        .onAppear {
            AVPlayer(url: Bundle.main.url(forResource: "intro video", withExtension: "mov")!).play()
        }
        .onDisappear {
            AVPlayer(url: Bundle.main.url(forResource: "intro video", withExtension: "mov")!).pause()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
