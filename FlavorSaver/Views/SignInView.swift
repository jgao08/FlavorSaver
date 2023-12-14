import SwiftUI

struct SignInView: View {
  
  @State var email: String = ""
  @State var password: String = ""
  @State var showPassword: Bool = false
  @State var loginFailed: Bool = false
  @State var user: User? = nil
  
  var isSignInButtonDisabled: Bool {
    [email, password].contains(where: \.isEmpty)
  }
  
  var body: some View {
    NavigationStack{
      VStack(alignment: .leading, spacing: 15) {
        Spacer()
        Form{
          Section{
            HStack{
              Text("Email")
                .frame(width: 100, alignment: .leading)
              TextField("Email", text: $email)
            }
            HStack{
              Text("Password")
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
              SecureField("Password", text: $password)
            }
          }
          .listRowBackground(Color(UIColor.lightGray).opacity(0.2))
        }
        .scrollContentBackground(.hidden)
        .scrollDisabled(true)
        
        
        Spacer()
        //        https://stackoverflow.com/questions/67394432/navigate-after-successful-login-with-swiftui
        
        HStack{
          Spacer()
          Text("Login Failed")
            .foregroundStyle(loginFailed ? Color.red : Color.clear)
          Spacer()
        }
        
        Button {
          print("do login action")
          Task{
            do{
              let loggedInUser = try await AccountManager.login(email: email, password: password)
              self.user = loggedInUser
              let scene = UIApplication.shared.connectedScenes.first
              if let windowScene = scene as? UIWindowScene {
                if let user = user {
                  let viewController = UIHostingController(rootView: ContentView(user: user))
                  windowScene.windows.first?.rootViewController = viewController
                }
              }
            }catch{
              print("login failed")
              loginFailed = true
            }
          }
        } label: {
          Text("Sign In")
            .font(.title2)
            .foregroundColor(isSignInButtonDisabled ? .black : .white)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity) // how to make a button fill all the space available horizontally
        .background(
          isSignInButtonDisabled ?
          Color.gray.opacity(0.25) : Color.blue
        )
        .cornerRadius(8)
        .disabled(isSignInButtonDisabled)
        .padding(.horizontal)
        .padding(.bottom)
      }
    }
    .navigationTitle("Sign In")
    .navigationBarTitleDisplayMode(.large)
  }
}


//#Preview{
//  SignInView()
//}
