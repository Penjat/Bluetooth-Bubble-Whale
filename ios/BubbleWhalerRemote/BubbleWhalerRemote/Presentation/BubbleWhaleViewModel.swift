import Foundation
import Combine
/// i/o
enum BubbleWhaleIntent {
	case startedUp
}

enum BubbleWhaleViewResult {
	case startUp
}

struct BubbleWhaleViewState {
	let text: String
}

enum BubbleWhaleViewEffect {
	case someEffect
}

/// View Model
class BubbleWhaleViewModel {
	/// - Input
	let intents = PassthroughSubject<BubbleWhaleIntent, Never>()

	public func processIntent(intent: BubbleWhaleIntent) {
		intents.send(intent)
	}
	/// - Side effects
	lazy var results = intents.flatMap { _ in
		return Just<BubbleWhaleViewResult>(.startUp)
	}

	/// - Output
	lazy var viewState = results.compactMap { (viewResult) -> BubbleWhaleViewState in
		switch viewResult {
		case .startUp:
		return BubbleWhaleViewState(text: "View State from the view model.")
		}
	}

	lazy var viewEffects = results.compactMap { (BubbleWhaleViewResult) -> BubbleWhaleViewEffect? in
		return nil
	}
}

