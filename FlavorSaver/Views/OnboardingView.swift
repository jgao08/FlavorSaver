import SwiftUI

struct OnboardingView: View {
  
  @State var name: String = ""
  @State var password: String = ""
  @State var showPassword: Bool = false
  
  var isSignInButtonDisabled: Bool {
    [name, password].contains(where: \.isEmpty)
  }
  
  var body: some View {
    NavigationStack{
      VStack(alignment: .leading, spacing: 15) {
        Spacer()
        HStack{
          Spacer()
          Text("Flavor Saver")
            .font(.largeTitle)
            .bold()
            .foregroundStyle(
              Color.red
            )
          Spacer()
        }
        HStack{
          Spacer()
          Text("Keep all your recipes in one place")
            .font(.headline)
          Spacer()
        }
        
        Spacer()
        NavigationLink(destination: SignUpView(), label: {
          HStack{
            Text("Get Started")
              .font(.title2)
              .bold()
              .foregroundColor(.white)
          }
          .frame(height: 50)
          .frame(maxWidth: .infinity)
          .background(Color.blue)
          .cornerRadius(10)
          .padding(.horizontal)
        })
        
        NavigationLink(destination: SignInView(), label: {
          HStack{
            Text("I Already Have An Account")
              .font(.title2)
              .bold()
              .foregroundColor(.blue)
          }
          .frame(height: 50)
          .frame(maxWidth: .infinity)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.clear)
              .stroke(Color.blue, lineWidth: 2)
          )
          .padding(.horizontal)
          .padding(.bottom)
        })
//        Spacer()
      }
    }
  }
}

#Preview{
  OnboardingView()
}
