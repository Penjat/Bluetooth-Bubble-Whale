import UIKit
import CoreBluetooth

enum WhaleBubbleState {
	case unknown, makingBubbles, idle
}

enum WhaleConnectedState {
	case notConnected, scanning, detected, connected
}

class BubbleWhaleRemoteViewController: UIViewController {
	var bluetoothSerial: BluetoothSerial!
	var bubbleWhalePeripheral: CBPeripheral!
	var myChar: CBCharacteristic?

	var whaleConnectedState = WhaleConnectedState.notConnected {
		didSet {
			switch whaleConnectedState {
			case .connected:
				bubbleWhaleStatusLabel.text = "Bubble Whale Connected."
			case .detected:
				bubbleWhaleStatusLabel.text = "Bubble Whale detected, attempting to connect..."
			case .notConnected:
				bubbleWhaleStatusLabel.text = "Bubble Whale not connected."
				whaleBubbleState = .unknown
			case .scanning:
				bubbleWhaleStatusLabel.text = "Scanning for BubbleWhale..."
			}
		}
	}
	var whaleBubbleState = WhaleBubbleState.unknown {
		didSet {
			switch whaleBubbleState {
			case .idle:
				whaleImageLabel.tintColor = .bubbleStateIdle
				bubbleWhaleActiveLabel.text = "The Whale is not making bubles."
				UIView.animate(withDuration: 1.0, animations: {
					self.onButton.alpha = 1.0
				})
			case .makingBubbles:
				whaleImageLabel.tintColor = .bubbleStateMakingBubbles
				bubbleWhaleActiveLabel.text = "The Whale is making bubles."
				UIView.animate(withDuration: 1.0, animations: {
					self.onButton.alpha = 1.0
				})
			case .unknown:
				whaleImageLabel.tintColor = .bubbleStateUnknown
				bubbleWhaleActiveLabel.text = "?"
				UIView.animate(withDuration: 1.0, animations: {
					self.onButton.alpha = 0.0
				})
			}
		}
	}

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
		return label
	}()

	let bubbleWhaleActiveLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.text = ""
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
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpViews();
		bluetoothSerial = BluetoothSerial(delegate: self)
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
		guard whaleConnectedState == .connected else {
			return
		}
		switch whaleBubbleState {
		case .makingBubbles:
			let data = "f".data(using: .utf8)!
			bluetoothSerial.sendDataToDevice(data)
		case .idle:
			let data = "o".data(using: .utf8)!
			bluetoothSerial.sendDataToDevice(data)
		case .unknown:
			let data = "s".data(using: .utf8)!
			bluetoothSerial.sendDataToDevice(data)
		}
	}

	public func pressedOn() {
		//TODO: write this
	}

	public func pressedOff() {
		//TODO: write this
	}
}

extension BubbleWhaleRemoteViewController: BluetoothSerialDelegate {
	func serialDidChangeState() {
		switch bluetoothSerial.centralManager.state {
		case .unknown:
			print("central.state is .unknown")
		case .resetting:
			print("central.state is .resetting")
		case .unsupported:
			print("central.state is .unsupported")
		case .unauthorized:
			print("central.state is .unauthorized")
		case .poweredOff:
			print("central.state is .poweredOff")
		case .poweredOn:
			print("central.state is .poweredOn")
			whaleConnectedState = .scanning
			bluetoothSerial.startScan()
		}
	}

	func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
		whaleConnectedState = .notConnected
	}

	func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
		print(peripheral)
		if peripheral.name == "Bubble-Whale" {
			bluetoothSerial.connectToPeripheral(peripheral)
		}
	}
	func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {
		whaleConnectedState = .notConnected
	}
	func serialIsReady(_ peripheral: CBPeripheral){
		whaleConnectedState = .connected
		let data = "f".data(using: .utf8)!
		bluetoothSerial.sendDataToDevice(data)
		print("serial is ready")
	}
	func serialDidReceiveData(_ data: Data){
		print("recieved data: \(data)")
	}

	func serialDidReceiveBytes(_ bytes: [UInt8]) {
		print("did recieve bytes: \(bytes)")
	}

	func serialDidReceiveString(_ message: String) {
		print("did recieve string: \(message)")
		if message == "WHALE-ON" {
			whaleBubbleState = .makingBubbles
		}

		if message == "WHALE-OFF" {
			whaleBubbleState = .idle
		}
	}
}
