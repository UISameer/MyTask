import SwiftUI

struct PickerComponent: View {
    
    @State private var pickerFilters: [String] = ["Active", "Completed"]
    @Binding var defaultPickerSelectedItem: String
    
    var body: some View {
        Picker("Filter", selection: $defaultPickerSelectedItem) {
            ForEach(pickerFilters, id: \.self) {
                Text($0)
            }
        }.pickerStyle(.segmented)
    }
}

#Preview {
    PickerComponent(defaultPickerSelectedItem: .constant("Active"))
}
