import UIKit
import Combine

class BubbleWhaleViewController: UIViewController {
	let viewModel = BubbleWhaleViewModel()
	private var cancelBag = Set<AnyCancellable>()

	lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		return stack
	}()

	let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "this is the initial value"
		return label
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		let _ = viewModel.viewState.sink { (viewState) in
			self.titleLabel.text = viewState.text
		}.store(in: &cancelBag)
		setUpViews()
		viewModel.processIntent(intent: .startedUp)
	}

	public func setUpViews() {
		view.backgroundColor = .gray
		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true

		mainStack.addArrangedSubview(titleLabel)
	}
}
