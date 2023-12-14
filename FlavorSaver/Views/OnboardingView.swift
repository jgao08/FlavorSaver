import SwiftUI

struct OnboardingView: View {
    
    @State var name: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    //  @ObservedObject var loginManager : LoginManager
    
    var isSignInButtonDisabled: Bool {
        [name, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 15) {
                Spacer()
                
                Image("spice")
                    .resizable()
                    .frame(width: 100, height: 175)
                Text("Flavor Saver")
                    .font(.largeTitle)
                    .bold()
                Text("Savor every step, save every ounce of flavor.")
                
                Spacer()
                
                NavigationLink(destination: SignUpView(), label: {
                    HStack{
                        Text("Get Started")
                            .foregroundColor(.black)
                            .font(.title3)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                })
                
                NavigationLink(destination: SignInView(), label: {
                    HStack{
                        Text("I Already Have An Account")
                            .foregroundColor(.black)
                            .font(.title3)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clear)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                })
            }
            .foregroundColor(.white)
            .background(Color.orange)
            
        }
    }
}

//#Preview{
//  OnboardingView()
//}
