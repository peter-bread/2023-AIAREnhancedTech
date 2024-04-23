import SwiftUI

/// Page for a description of the app and instructions for how to use it.
struct InstructionsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 30) {
                Text("Welcome to Galasa AI AR")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Your gateway to an enhanced technical document experience!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("This app is meticulously crafted to elevate your interaction with Galasa's technical documents.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Unlock the full potential of your documents by scanning the QR codes accompanying the diagrams using your smartphone.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("On the AR View page, engage with our AI chatbot, Antonio, and obtain explanations and additional information about the diagrams.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarTitle("Instructions", displayMode: .inline)
            .padding()
        }
    }
}
