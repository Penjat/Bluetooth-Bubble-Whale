import UIKit
import CoreBluetooth

class BubbleWhaleRemoteViewController: UIViewController {
	//	var centralManager: CBCentralManager!
	var bluetoothSerial: BluetoothSerial!
	var bubbleWhalePeripheral: CBPeripheral!
	var myChar: CBCharacteristic?
	lazy var mainStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fillEqually
		return stack
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
		button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
		button.addTarget(self, action: #selector(pressedOn), for: .touchUpInside)
		return button
	}()

	let offButton: UIButton = {
		let button = UIButton()
		button.setTitle("OFF", for: .normal)
		button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
		button.addTarget(self, action: #selector(pressedOff), for: .touchUpInside)
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpViews();
		//		centralManager = CBCentralManager(delegate: self, queue: nil)
		bluetoothSerial = BluetoothSerial(delegate: self)

	}

	public func setUpViews() {
		view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
		view.addSubview(mainStack)
		mainStack.translatesAutoresizingMaskIntoConstraints = false
		mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
		mainStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
		mainStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		mainStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true

		mainStack.addArrangedSubview(bubbleWhaleStatusLabel)
		mainStack.addArrangedSubview(bubbleWhaleActiveLabel)
		mainStack.addArrangedSubview(onButton)
		mainStack.addArrangedSubview(offButton)
	}

	@objc
	func pressedOn() {
		let data = "o".data(using: .utf8)!
		bluetoothSerial.sendDataToDevice(data)
	}

	@objc
	func pressedOff() {
		let data = "f".data(using: .utf8)!
		bluetoothSerial.sendDataToDevice(data)
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
			bubbleWhaleStatusLabel.text = "Scanning..."
			bluetoothSerial.startScan()
		}
	}



	func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {

	}

	func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
		print(peripheral)
		if peripheral.name == "Bubble-Whale" {
			bubbleWhaleStatusLabel.text = "Bubble Whale detected, attempting to connect..."
			bluetoothSerial.connectToPeripheral(peripheral)
		}
	}
	func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {
		bubbleWhaleStatusLabel.text = "Failed to connect."
	}
	func serialIsReady(_ peripheral: CBPeripheral){
		bubbleWhaleStatusLabel.text = "Bubble Whale Connected."
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
			bubbleWhaleActiveLabel.text = "The Whale is making bubles."
		}

		if message == "WHALE-OFF" {
			bubbleWhaleActiveLabel.text = "The Whale is not making bubles."
		}
	}
}
