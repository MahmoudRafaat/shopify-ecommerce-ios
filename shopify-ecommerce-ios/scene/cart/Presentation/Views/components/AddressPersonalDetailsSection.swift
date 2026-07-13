import SwiftUI

struct AddressPersonalDetailsSection: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var phone: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Personal Details")
                .font(.headline)
                .foregroundColor(AppColor.textSecondary)
                .padding(.horizontal, 28)
            
            CustomTextField(placeholder: "First Name", type: .name, hasError: false, text: $firstName)
            CustomTextField(placeholder: "Last Name", type: .name, hasError: false, text: $lastName)
            CustomTextField(placeholder: "Phone Number", type: .phone, hasError: false, text: $phone)
        }
        .padding(.top, 16)
    }
}
