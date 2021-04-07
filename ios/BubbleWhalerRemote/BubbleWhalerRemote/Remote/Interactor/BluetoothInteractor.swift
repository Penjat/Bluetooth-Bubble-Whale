import Foundation
import CoreBluetooth
import Combine

enum WhaleState {
	case scanning
	case detected
	case connected(BubbleStatus)
	case notConnected
}

enum BubbleStatus {
	case unknown
	case makingBubbles
	case notMakingBubbles
}

class BluetoothInteractor: BluetoothSerialDelegate {
	var bluetoothSerial: BluetoothSerial!
	var bubbleWhalePeripheral: CBPeripheral!
	var myChar: CBCharacteristic?
	public let output = PassthroughSubject<WhaleState, Never>()

	init() {
		bluetoothSerial = BluetoothSerial(delegate: self)
	}
	
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
			output.send(.scanning)
			bluetoothSerial.startScan()
		@unknown default:
			fatalError()
		}
	}

	func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
		output.send(.notConnected)
	}

	func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
		print(peripheral)
		if peripheral.name == "Bubble-Whale" {
			bluetoothSerial.connectToPeripheral(peripheral)
		}
	}
	func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {
		output.send(.notConnected)
	}
	func serialIsReady(_ peripheral: CBPeripheral){
		output.send(.connected(.unknown))
		let data = "s".data(using: .utf8)!
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
			output.send(.connected(.makingBubbles))
		}

		if message == "WHALE-OFF" {
			output.send(.connected(.notMakingBubbles))
		}
	}

	public func turnOnBubbles() {
		print("turning on bubbles")
		let data = "o".data(using: .utf8)!
		bluetoothSerial.sendDataToDevice(data)
	}

	public func turnOffBubbles() {
		print("turning off bubbles")
		let data = "f".data(using: .utf8)!
		bluetoothSerial.sendDataToDevice(data)
	}

	public func getBubbleState() {
		//TODO: broadcast this over bluetooth instead
		let data = "s".data(using: .utf8)!
		bluetoothSerial.sendDataToDevice(data)
	}
}
