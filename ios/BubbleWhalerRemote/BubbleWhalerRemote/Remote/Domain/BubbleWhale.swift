struct BubbleWhale {
	var whaleState: WhaleState
	var bubbleStatus: BubbleStatus {
		switch whaleState {
		case .connected(let bubbleState):
			return bubbleState
		default:
			return .unknown
		}
	}
}
