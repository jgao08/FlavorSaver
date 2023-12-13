import SwiftUI
import AVKit

struct LaunchScreenView: View {
    var body: some View {
        VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "intro video", withExtension: "mov")!)) {
            // You can customize the appearance of the video player controls here.
        }
        .onAppear {
            // Start playing the video when the view appears.
            AVPlayer(url: Bundle.main.url(forResource: "intro video", withExtension: "mov")!).play()
        }
        .onDisappear {
            // Pause the video when the view disappears.
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
