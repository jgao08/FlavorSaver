import SwiftUI

struct SignUpView: View {
  @State var email: String = ""
  @State var name: String = ""
  @State var password: String = ""
  @State var showPassword: Bool = false
  @State var selectedImg: Int = 0
  
  var isSignInButtonDisabled: Bool {
    [email, name, password].contains(where: \.isEmpty)
  }
  
  
  var body: some View {
    NavigationStack{
      VStack{
        ScrollView(.horizontal, content: {
          HStack{
            Image("rat")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 100, height: 100, alignment: .center)
              .clipShape(Circle())
              .overlay(
                Circle()
                  .stroke(selectedImg == 0 ? Color.blue : Color.clear, lineWidth: 5)
                  .fill(selectedImg == 0 ? Color.gray.opacity(0.5): Color.clear)
              )
              .overlay(
                Image(systemName: "checkmark.circle.fill")
                  .foregroundStyle(selectedImg == 0 ? Color.blue: Color.clear)
                  .font(.largeTitle)
              )
              .onTapGesture {
                print("chose pic 0")
//                TODO: show image is selected
                selectedImg = 0
              }
            Image("raccoon")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 100, height: 100, alignment: .center)
              .clipShape(Circle())
              .overlay(
                Circle()
                  .stroke(selectedImg == 1 ? Color.blue : Color.clear, lineWidth: 5)
                  .fill(selectedImg == 1 ? Color.gray.opacity(0.5): Color.clear)
              )
              .overlay(
                Image(systemName: "checkmark.circle.fill")
                  .foregroundStyle(selectedImg == 1 ? Color.blue: Color.clear)
                  .font(.largeTitle)
              )
              .onTapGesture {
                print("chose pic 1")
                selectedImg = 1
              }
            Image("guy")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 100, height: 100, alignment: .center)
              .clipShape(Circle())
              .overlay(
                Circle()
                  .stroke(selectedImg == 2 ? Color.blue : Color.clear, lineWidth: 4)
                  .fill(selectedImg == 2 ? Color.gray.opacity(0.5): Color.clear)
              )
              .overlay(
                Image(systemName: "checkmark.circle.fill")
                  .foregroundStyle(selectedImg == 2 ? Color.blue: Color.clear)
                  .font(.largeTitle)
              )
              .onTapGesture {
                print("chose pic 2")
//                TODO: show image is selected
                selectedImg = 2
              }
          }
          .padding()
        })
        
        Form{
          Section{
            HStack{
              Text("Email")
                .frame(width: 100, alignment: .leading)
              TextField("Email", text: $email)
            }
          }
          .listRowBackground(Color(UIColor.lightGray).opacity(0.2))

          Section{
            HStack{
              Text("Username")
                .frame(width: 100, alignment: .leading)
              TextField("Username", text: $name)
            }
          }
          .listRowBackground(Color(UIColor.lightGray).opacity(0.2))

          Section{
            HStack{
              Text("Password")
                .frame(width: 100, alignment: .leading)
              SecureField("Password", text: $password)
            }
          }
          .listRowBackground(Color(UIColor.lightGray).opacity(0.2))
        }
        .scrollContentBackground(.hidden)
        .scrollDisabled(true)
        
        Spacer()
        Button {
          print("do signup action")
        } label: {
          Text("Sign Up")
            .font(.title2)
            .bold()
            .foregroundColor(.white)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(
          Color.blue
        )
        .cornerRadius(20)
        .padding(.horizontal)
        .padding(.bottom)
      }
      .navigationBarTitle("Sign Up")
    }
  }
}

#Preview{
  SignUpView()
}
