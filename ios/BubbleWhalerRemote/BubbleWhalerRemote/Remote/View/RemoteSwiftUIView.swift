import SwiftUI

struct RemoteSwiftUIView: View {
    var body: some View {
		VStack(alignment: .center, spacing: 20) {
			Text("Bubble Whale Status")
			Spacer()
			Image("Whale")
			Text("Bubble Status")
			Spacer()
			Button("ON") {
				print("Button tapped!")
			}.padding(32)
			.border(Color.black, width: 2)

		}.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
	}
}

struct RemoteSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteSwiftUIView()
    }
}
