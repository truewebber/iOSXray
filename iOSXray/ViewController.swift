import UIKit

class ViewController: UIViewController {
	var window: UIWindow?

	override func viewDidLoad() {
		super.viewDidLoad()

		//window and current view
		self.window = UIWindow(frame: UIScreen.self.main.bounds)
		self.view.backgroundColor = UIColor.white

		let myView: UIView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: (self.window?.frame.width)!, height: 80)))
		myView.backgroundColor = UIColor.init(red: 0.25, green: 0.37, blue: 0.53, alpha: 1)
		self.view.addSubview(myView)

		let myLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 20), size: CGSize(width: (self.window?.frame.width)!, height: 60)))
		myLabel.text = "Hello World!"
		myLabel.textColor = UIColor.white
		myLabel.font = myLabel.font.withSize(30)
		myLabel.textAlignment = .center
		self.view.addSubview(myLabel)


	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

