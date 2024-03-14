import SwiftUI

/// Main `View` for the app
struct ContentView: View {
    
    /// An instance of QRCodeService to handle loading QR codes.
    @StateObject private var qrCodeService = QRCodeService()
    
    /// A state variable that determines whether the AR view should be reset.
    ///
    /// When this variable is set to true, the AR view is reset.
    ///
    /// It should be set back to false after the reset is complete.
    @State private var shouldReset = false
    // It is bound to a corresponding variable in `ARViewContainer`.

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: { MyARView(referenceImages: qrCodeService.referenceImages, shouldReset: $shouldReset)
                }) {
                    Text("Open AR View")
                }
                .disabled(qrCodeService.referenceImages.isEmpty)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
