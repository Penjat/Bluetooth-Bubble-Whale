enum WhaleState {
	case scanning
	case detected
	case connected(BubbleStatus)
	case notConnected

	var bubbleStatus: BubbleStatus {
		switch self {
		case .connected(let bubbleState):
			return bubbleState
		default:
			return .unknown
		}
	}
}

enum BubbleStatus {
	case unknown
	case makingBubbles
	case notMakingBubbles
}
