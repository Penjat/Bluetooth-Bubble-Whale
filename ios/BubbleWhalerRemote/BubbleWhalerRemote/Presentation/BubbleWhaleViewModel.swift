import Foundation
import Combine
/// i/o
enum BubbleWhaleIntent {
	case startedUp
	case whaleStateChanged(WhaleState)
	case pressedButton
}

enum BubbleWhaleViewResult {
	case startedScan
	case connected
	case makingBubbles
	case notMakingBubbles
}

struct BubbleWhaleViewState {
	init(
		whaleStatusText: String,
		showButton: Bool,
		buttonText: String = "") {
		self.whaleStatusText = whaleStatusText
		self.showButton = showButton
		self.buttonText = buttonText
	}

	let whaleStatusText: String
	let showButton: Bool
	let buttonText: String
}

enum BubbleWhaleViewEffect {
	case someEffect
}

/// View Model
class BubbleWhaleViewModel {
	// TODO: use dependency injection
	let bluetoothInteractor = BluetoothInteractor()

	/// - Input
	let intents = PassthroughSubject<BubbleWhaleIntent, Never>()

	public func processIntent(intent: BubbleWhaleIntent) {
		intents.send(intent)
	}
	/// - Side effects
	lazy var results = intents.flatMap { (intent) -> Publishers.Sequence<[BubbleWhaleViewResult], Never> in
		switch intent {
		case .startedUp:
			return [BubbleWhaleViewResult.startedScan].publisher
		}
	}

	/// - Output
	lazy var viewState = results.compactMap { (viewResult) -> BubbleWhaleViewState in
		switch viewResult {
		case .startedScan:
		return BubbleWhaleViewState(whaleStatusText: "scanning for Bubble Whale...", showButton: false)
		case .connected:
			return BubbleWhaleViewState(whaleStatusText: "Connected to Bubble Whale.", showButton: false)
		case .makingBubbles:
			return BubbleWhaleViewState(whaleStatusText: "Connected to Bubble Whale.", showButton: false)
		case .notMakingBubbles:
			return BubbleWhaleViewState(whaleStatusText: "scanning for Bubble Whale...", showButton: false)
		}
	}

	lazy var viewEffects = results.compactMap { (BubbleWhaleViewResult) -> BubbleWhaleViewEffect? in
		return nil
	}

	init() {
		let _ = bluetoothInteractor.output.sink { (whaleState) in
			self.processIntent(intent: .whaleStateChanged(whaleState))
		}
	}
}

