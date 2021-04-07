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
		Color(.appBackground).ignoresSafeArea()
			.overlay(
			VStack(alignment: .center, spacing: 20) {
				Text(model.whaleStatusText).foregroundColor(Color(.white)).font(Font(UIFont.connectionStatus)).padding(32)
				Spacer()
				Image("Whale").foregroundColor(Color(.bubbleStateIdle))
				Text(model.bubbleStatusText).font(Font(UIFont.bubbleStatus))
				Spacer()
				Button(model.buttonText) {
					viewModel.processIntent(intent: .pressedButton)
				}.foregroundColor(Color(.mainButtonOff)).padding(32)
				.border(Color(.bubbleStateIdle), width: 4).font(Font(UIFont.mainButtonFont))
			})
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
