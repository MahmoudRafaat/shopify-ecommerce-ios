
struct SettingsRowView: View {
    let icon: String
    let title: String
    var style: SettingsRowStyle = .navigation
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(style.iconColor)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16, weight: style.titleWeight))
                    .foregroundStyle(style.titleColor)
                
                Spacer()
                
                switch style {
                case .navigation:
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .foregroundStyle(Color(.systemGray3))
                    
                case .toggle(let binding):
                    Toggle("", isOn: binding)
                        .labelsHidden()
                        .tint(Color.pink)
                    
                case .destructive:
                    EmptyView()
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(action == nil)
    }
}

enum SettingsRowStyle {
    case navigation
    case toggle(Binding<Bool>)
    case destructive
    
    var iconColor: Color {
        switch self {
        case .destructive:
            return .red
        default:
            return Color(.darkGray)
        }
    }
    
    var titleColor: Color {
        switch self {
        case .destructive:
            return .red
        default:
            return .primary
        }
    }
    
    var titleWeight: Font.Weight {
        switch self {
        case .destructive:
            return .semibold
        default:
            return .regular
        }
    }
}
