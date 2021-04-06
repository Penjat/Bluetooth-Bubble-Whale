import UIKit
import Combine

class BubbleWhaleViewController: UIViewController {
	let viewModel = BubbleWhaleViewModel()
	private var cancelBag = Set<AnyCancellable>()

	lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fillEqually
		stack.spacing = 20
		return stack
	}()

	let whaleImageLabel: UIView = {
		let whaleImage = UIImageView(image: UIImage(named: "Whale.png"))
		whaleImage.contentMode = .scaleAspectFit
		return whaleImage
	}()

	let bubbleWhaleStatusLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.text = ""
		label.numberOfLines = 0
		label.font = .connectionStatus
		return label
	}()

	let bubbleWhaleActiveLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.text = ""
		label.font = .bubbleStatus
		return label
	}()

	let onButton: UIButton = {
		let button = UIButton()
		button.setTitle("ON", for: .normal)
		button.setTitleColor(.mainButtonText, for: .normal)
		button.backgroundColor = .mainButtonOn
		button.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
		button.layer.cornerRadius = 20
		button.alpha = 0.0
		button.titleLabel?.font = .mainButtonFont
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		let _ = viewModel.viewState.sink { (viewState) in
			
		}.store(in: &cancelBag)
		setUpViews()
		viewModel.processIntent(intent: .startedUp)
	}

	public func setUpViews() {
		view.backgroundColor = .appBackground
		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -16).isActive = true

		mainStack.addArrangedSubview(bubbleWhaleStatusLabel)
		mainStack.addArrangedSubview(whaleImageLabel)
		mainStack.addArrangedSubview(bubbleWhaleActiveLabel)
		mainStack.addArrangedSubview(onButton)

	}

	@objc
	public func pressedButton() {
//		viewModel.processIntent(intent: )
	}
}
