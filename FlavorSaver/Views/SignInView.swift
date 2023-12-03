import SwiftUI

struct SignInView: View {
  
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
        Form{
          Section{
            HStack{
              Text("Username")
                .frame(width: 100, alignment: .leading)
              TextField("Username", text: $name)
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
//        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

        
        Spacer()
        
        Button {
          print("do login action")
        } label: {
          Text("Sign In")
            .font(.title2)
            .bold()
            .foregroundColor(isSignInButtonDisabled ? .black : .white)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity) // how to make a button fill all the space available horizontaly
        .background(
          isSignInButtonDisabled ?
          Color.gray.opacity(0.25) : Color.blue
        )
        .cornerRadius(20)
        .disabled(isSignInButtonDisabled) // how to disable while some condition is applied
        .padding(.horizontal)
        .padding(.bottom)
      }
      .navigationTitle("Sign In")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}

#Preview{
  SignInView()
}
