import re

def update_file(path, replacements):
    with open(path, 'r') as f:
        content = f.read()
    for old, new in replacements:
        content = content.replace(old, new)
    with open(path, 'w') as f:
        f.write(content)

# 1. Update Tab enum
update_file('scene/TabBar/Tab.swift', [
    ('case profile = "Profile"', 'case settings = "Settings"'),
    ('case .profile: return isActive ? "person.fill" : "person"', 'case .settings: return isActive ? "gearshape.fill" : "gearshape"')
])

# 2. Update TabBarView
update_file('scene/TabBar/TabBarView.swift', [
    ("""                NavigationStack {
                    ProfileDetailsView(viewModel: ProfileViewModel())
                }
                .tag(Tab.profile)""",
     """                NavigationStack {
                    SettingsView()
                }
                .tag(Tab.settings)""")
])

# 3. Update CustomTabBarView
update_file('scene/TabBar/CustomTabBarView.swift', [
    ('tab == .cart || tab == .wishlist || tab == .profile', 'tab == .cart || tab == .wishlist || tab == .settings')
])

# 4. Update HomeCoordinator
update_file('scene/Home/Coordinator/HomeCoordinator.swift', [
    ('case settings', 'case profileDetails'),
    ("""    func goToSettings() {
        print("Pushing from coordinator:", ObjectIdentifier(self))
        navigationPath.append(Destination.settings)
    }""",
     """    func goToProfile() {
        print("Pushing from coordinator:", ObjectIdentifier(self))
        navigationPath.append(Destination.profileDetails)
    }""")
])

# 5. Update HomeRootView
update_file('scene/Home/Presentation/Views/Screen/HomeRootView.swift', [
    ('case .settings:', 'case .profileDetails:'),
    ("""                        SettingsView()
                            .navigationBarBackButtonHidden(false)""",
     """                        ProfileDetailsView(viewModel: ProfileViewModel())
                            .navigationBarBackButtonHidden(false)""")
])

# 6. Update HeaderView
update_file('Core/helper/SharedViews/Components/HeaderView.swift', [
    ("""                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                        .font(.title3)
                        .foregroundStyle(.black)
                }
                                               
                Spacer()""",
     """                Spacer()"""),
    ("""                Button {
                    
                } label: {""",
     """                Button {
                    onMenuTap?()
                } label: {""")
])

# 7. Update HomeScreenView
update_file('scene/Home/Presentation/Views/Screen/HomeScreenView.swift', [
    ('coordinator.goToSettings()', 'coordinator.goToProfile()')
])

# 8. Update ProfileDetailsView (remove NavigationStack)
update_file('scene/Profile/presentation/view/ProfileDetailsView.swift', [
    ("""    var body: some View {
        NavigationStack {""",
     """    var body: some View {"""),
    ("""            .onAppear {
                if viewModel.uiState.isLoggedIn {
                    Task { await viewModel.loadProfile() }
                }
            }
        }
        .fullScreenCover""",
     """            .onAppear {
                if viewModel.uiState.isLoggedIn {
                    Task { await viewModel.loadProfile() }
                }
            }
        .fullScreenCover""")
])

print("Updates completed.")
