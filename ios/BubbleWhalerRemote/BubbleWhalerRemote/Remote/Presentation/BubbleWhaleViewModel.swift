import Foundation
import Combine
/// i/o
enum BubbleWhaleIntent {
	case whaleStateChanged(WhaleState)
	case pressedButton
}

enum BubbleWhaleViewResult {
	case startedScan
	case detected
	case connected
	case notConnected
	case makingBubbles
	case notMakingBubbles
}

struct BubbleWhaleViewState {
	init(
		whaleStatusText: String,
		bubbleStatusText: String,
		showButton: Bool,
		buttonText: String = "") {
		self.whaleStatusText = whaleStatusText
		self.bubbleStatusText = bubbleStatusText
		self.showButton = showButton
		self.buttonText = buttonText
	}
	let whaleStatusText: String
	let bubbleStatusText: String
	let showButton: Bool
	let buttonText: String
}

enum BubbleWhaleViewEffect {
	case onEffect
}

/// View Model
class BubbleWhaleViewModel {
	// TODO: use dependency injection
	let bluetoothInteractor: BluetoothInteractor
	var bubbleWhale = BubbleWhale(whaleState: .notConnected)
	private var cancelBag = Set<AnyCancellable>()

	/// - Input
	let intents = PassthroughSubject<BubbleWhaleIntent, Never>()

	public func processIntent(intent: BubbleWhaleIntent) {
		print("recieved intent")
		intents.send(intent)
	}
	/// - Side effects
	lazy var results = intents.flatMap { intent -> Publishers.Sequence<[BubbleWhaleViewResult], Never> in
		switch intent {
		case .whaleStateChanged(let whaleState):
			print("whale state changed \(whaleState)")
			return self.processWhaleStateChange(whaleState)
		case .pressedButton:
			return self.processPressedButton(self.bubbleWhale.bubbleStatus)
		}
	}

	func processPressedButton(_ bubbleStatus: BubbleStatus) -> Publishers.Sequence<[BubbleWhaleViewResult], Never> {
		switch bubbleStatus {
		case .makingBubbles:
			bluetoothInteractor.turnOffBubbles()
			break;
		case .notMakingBubbles:
			bluetoothInteractor.turnOnBubbles()
			break;
		case .unknown:
			bluetoothInteractor.getBubbleState()
		}
		return [].publisher
	}

	func processWhaleStateChange(_ whaleState: WhaleState) -> Publishers.Sequence<[BubbleWhaleViewResult], Never> {
		switch whaleState {
		case .scanning:
			self.bubbleWhale.whaleState = .notConnected
			return [BubbleWhaleViewResult.startedScan].publisher
		case .detected:
			self.bubbleWhale.whaleState = .detected
			return [BubbleWhaleViewResult.detected].publisher
		case .connected(let bubbleState):
			self.bubbleWhale.whaleState = .connected(bubbleState)
			return processBubbleStateChanged(bubbleState)
		case .notConnected:
			self.bubbleWhale.whaleState = .notConnected
			return [BubbleWhaleViewResult.notConnected].publisher
		}
	}

	func processBubbleStateChanged(_ bubbleState: BubbleStatus) -> Publishers.Sequence<[BubbleWhaleViewResult], Never> {
		switch bubbleState {
		case .unknown:
			return [BubbleWhaleViewResult.connected].publisher
		case .makingBubbles:
			return [BubbleWhaleViewResult.makingBubbles].publisher
		case .notMakingBubbles:
			return [BubbleWhaleViewResult.notMakingBubbles].publisher
		}
	}

	/// - Output
	lazy var viewState = results.compactMap { (viewResult) -> BubbleWhaleViewState in
		switch viewResult {

		case .startedScan:
		return BubbleWhaleViewState(
			whaleStatusText: "scanning for Bubble Whale...",
			bubbleStatusText: "",
			showButton: false)

		case .connected:
		return BubbleWhaleViewState(
			whaleStatusText: "Connected to Bubble Whale.",
			bubbleStatusText: "unknown",
			showButton: false)

		case .makingBubbles:
		return BubbleWhaleViewState(
			whaleStatusText: "Connected to Bubble Whale.",
			bubbleStatusText: "the whale is Making Bubbles",
			showButton: true,
			buttonText: "OFF")

		case .notMakingBubbles:
		return BubbleWhaleViewState(
			whaleStatusText: "Connected to Bubble Whale.",
			bubbleStatusText: "the whale is not making bubbles",
			showButton: true,
			buttonText: "ON")

		case .detected:
		return BubbleWhaleViewState(
			whaleStatusText: "Bubble Whale detected...",
			bubbleStatusText: "",
			showButton: false)

		case .notConnected:
		return BubbleWhaleViewState(
			whaleStatusText: "not connected",
			bubbleStatusText: "",
			showButton: false)
		}
	}

//	lazy var viewEffects = results.compactMap { result -> BubbleWhaleViewEffect? in
//		switch result {
//		case .makingBubbles:
//			return .onEffect
//		default:
//			return nil
//		}
//	}

	public init() {
		self.bluetoothInteractor = BluetoothInteractor()
		print("creating view model")
		bluetoothInteractor.output.sink { (whaleState) in
			print("recieved state change \(whaleState)")
			self.processIntent(intent: .whaleStateChanged(whaleState))
		}.store(in: &cancelBag)
	}

	deinit {
		cancelBag.removeAll()
	}
}
