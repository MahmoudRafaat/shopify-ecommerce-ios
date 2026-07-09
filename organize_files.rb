require 'xcodeproj'

project_path = 'shopify-ecommerce-ios.xcodeproj'
project = Xcodeproj::Project.open(project_path)

files_to_move = [
  "shopify-ecommerce-ios/Core/helper/AlertManager.swift",
  "shopify-ecommerce-ios/scene/UIState/HomeUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/CollectionUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/CartUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/FavoritesUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/ProductUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/PaymentUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/SearchUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/ProfileUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/ProductDetailsUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/OrdersUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/SignupUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/LoginUIState.swift",
  "shopify-ecommerce-ios/scene/UIState/SettingsUIState.swift"
]

# Helper to find or create group path from main group
def ensure_group(project, path_str)
  components = path_str.split('/')
  current_group = project.main_group
  components.each do |comp|
    next_group = current_group.children.find { |c| c.class == Xcodeproj::Project::Object::PBXGroup && (c.name == comp || c.path == comp) }
    if next_group.nil?
      next_group = current_group.new_group(comp, comp)
    end
    current_group = next_group
  end
  current_group
end

# Find the file references in main_group and move them
files_to_move.each do |path|
  file_name = File.basename(path)
  
  # Find in main group
  ref = project.main_group.files.find { |f| f.path == path || f.name == file_name }
  if ref
    # Determine correct group
    if file_name == "AlertManager.swift"
      group = ensure_group(project, "shopify-ecommerce-ios/Core/helper")
    else
      group = ensure_group(project, "shopify-ecommerce-ios/scene/UIState")
    end
    
    # Remove from main group
    ref.remove_from_project
    
    # Add to correct group
    new_ref = group.new_file(file_name)
    # The new_file method sets path based on group structure, we need to ensure it's correct
    # If the group has the correct path, the file ref will just be the file name.
    
    # Add back to build phase since remove_from_project removes it from build phases!
    target = project.targets.first
    target.source_build_phase.add_file_reference(new_ref)
  end
end

project.save
puts "Organized files successfully."
