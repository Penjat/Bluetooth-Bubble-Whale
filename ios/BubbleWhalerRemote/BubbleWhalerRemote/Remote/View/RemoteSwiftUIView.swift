import SwiftUI
import Combine

struct RemoteSwiftUIView: View {
	let viewModel: BubbleWhaleViewModel
	@ObservedObject private var model: RemoteSwiftUIModel

	init(viewModel: BubbleWhaleViewModel = BubbleWhaleViewModel()) {
		self.viewModel = viewModel
		self.model = RemoteSwiftUIModel(viewModel: self.viewModel)
	}

    var body: some View {
		VStack(alignment: .center, spacing: 20) {
			Text(model.whaleStatusText)
			Spacer()
			Image("Whale")
			Text(model.bubbleStatusText)
			Spacer()
			Button(model.buttonText) {
				viewModel.processIntent(intent: .pressedButton)
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

class RemoteSwiftUIModel: ObservableObject {
	private var cancelBag = Set<AnyCancellable>()
	@Published var bubbleStatusText = ""
	@Published var whaleStatusText = ""
	@Published var buttonText = ""

	init(viewModel: BubbleWhaleViewModel) {
		viewModel.viewState.sink { (viewState) in
			self.bubbleStatusText = viewState.bubbleStatusText
			self.whaleStatusText = viewState.whaleStatusText
			self.buttonText = viewState.buttonText
		}.store(in: &cancelBag)
	}
}
