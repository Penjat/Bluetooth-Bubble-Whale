import Foundation
import Combine
/// i/o
enum testIntent {
	case startedUp
}

enum testViewResult {
	case startUp
}

struct testViewState {
	let text: String
}

enum testViewEffect {
	case someEffect
}

/// View Model
class testViewModel {
	/// - Input
	let intents = PassthroughSubject<testIntent, Never>()

	public func processIntent(intent: testIntent) {
		intents.send(intent)
	}
	/// - Side effects
	lazy var results = intents.flatMap { _ in
		return Just<testViewResult>(.startUp)
	}

	/// - Output
	lazy var viewState = results.compactMap { (viewResult) -> testViewState in
		switch viewResult {
		case .startUp:
		return testViewState(text: "View State from the view model.")
		}
	}

	lazy var viewEffects = results.compactMap { (testViewResult) -> testViewEffect? in
		return nil
	}
}

