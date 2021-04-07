import UIKit
import Combine

class BubbleWhaleViewController: UIViewController {

	private var cancelBag = Set<AnyCancellable>()
	let viewModel = BubbleWhaleViewModel()

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

	let connectionStatusLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.text = ""
		label.numberOfLines = 0
		label.font = .connectionStatus
		return label
	}()

	let bubbleStatusLabel: UILabel = {
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
		viewModel.viewState.sink { (viewState) in
			self.bubbleStatusLabel.text = viewState.bubbleStatusText
			self.connectionStatusLabel.text = viewState.whaleStatusText
			self.onButton.setTitle(viewState.buttonText, for: .normal)
			UIView.animate(withDuration: 1.5, animations: {
				self.onButton.alpha = viewState.showButton ? 1 : 0
			})
		}.store(in: &cancelBag)

//		viewModel.viewEffects.sink { viewEffect in
//			switch viewEffect {
//			case .onEffect:
//				break
////				UIView.animate(withDuration: 0.5, delay: 0.0, options: [.autoreverse], animations: {
////					self.whaleImageLabel.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
////				}, completion: { _ in
////					self.whaleImageLabel.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
////				})
//			}
//		}.store(in: &cancelBag)
		setUpViews()
	}

	override func viewDidDisappear(_ animated: Bool) {
		cancelBag.removeAll()
	}

	public func setUpViews() {
		view.backgroundColor = .appBackground
		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -16).isActive = true

		mainStack.addArrangedSubview(connectionStatusLabel)
		mainStack.addArrangedSubview(whaleImageLabel)
		mainStack.addArrangedSubview(bubbleStatusLabel)
		mainStack.addArrangedSubview(onButton)
	}

	@objc
	public func pressedButton() {
		viewModel.processIntent(intent: .pressedButton)
	}
}
