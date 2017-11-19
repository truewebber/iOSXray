import UIKit

let delegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {
	var window: UIWindow?

	var ApplicationConfig: Config!

	override func viewDidLoad() {
		super.viewDidLoad()

		//window and current view
		self.window = UIWindow(frame: UIScreen.self.main.bounds)
		self.view.backgroundColor = UIColor.white

		if delegate.ApplicationConfig == nil {
			//Alert about connection
			let alert = UIAlertController(title: "Network is unavailable", message: "First launch required internet connection",
			                              preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Exit Application", style: .default, handler: {
				action in

				switch action.style {
				case .default:
					NSLog("Alert Default")

					exit(10)
				case .cancel:
					NSLog("Alert Cancel")
				case .destructive:
					NSLog("Alert Destructive")
				}
			}))

			NSLog("WAIT until tap exit")
			self.present(alert, animated: true, completion: nil)

			return
		}

		self.view.backgroundColor = UIColor.init(
				red: CGFloat(delegate.ApplicationConfig.screens[0].bgColor.red),
				green: CGFloat(delegate.ApplicationConfig.screens[0].bgColor.green),
				blue: CGFloat(delegate.ApplicationConfig.screens[0].bgColor.blue),
				alpha: CGFloat(delegate.ApplicationConfig.screens[0].bgColor.alpha)
		)

		for myUiView in delegate.ApplicationConfig.screens[0].views {
			let uiViewHeight = (myUiView.height != -1) ? myUiView.height : Int((self.window?.frame.height)!);
			let uiViewWidth = (myUiView.width != -1) ? myUiView.width : Int((self.window?.frame.width)!);

			//views
			let myView: UIView = UIView(frame: CGRect(
					origin: CGPoint(x: myUiView.posX, y: myUiView.posY),
					size: CGSize(width: uiViewWidth, height: uiViewHeight)
			))
			myView.backgroundColor = UIColor.init(
					red: CGFloat(myUiView.bgColor.red), green: CGFloat(myUiView.bgColor.green),
					blue: CGFloat(myUiView.bgColor.blue), alpha: CGFloat(myUiView.bgColor.alpha)
			)
			self.view.addSubview(myView)

			//labels
			for myUiLabel in myUiView.labels {
				let uiLabelHeight = (myUiLabel.height != -1) ? myUiLabel.height : Int((self.window?.frame.height)!);
				let uiLabelWidth = (myUiLabel.width != -1) ? myUiLabel.width : Int((self.window?.frame.width)!);

				let myLabel = UILabel(frame: CGRect(
						origin: CGPoint(x: myUiLabel.posX, y: myUiLabel.posY),
						size: CGSize(width: uiLabelWidth, height: uiLabelHeight)
				))
				myLabel.text = myUiLabel.text
				myLabel.textColor = UIColor.init(
						red: CGFloat(myUiLabel.color.red), green: CGFloat(myUiLabel.color.green),
						blue: CGFloat(myUiLabel.color.blue), alpha: CGFloat(myUiLabel.color.alpha)
				)
				myLabel.font = myLabel.font.withSize(CGFloat(myUiLabel.textSize))
				switch myUiLabel.align {
				case ".left":
					myLabel.textAlignment = .left
				case ".right":
					myLabel.textAlignment = .right
				case ".center":
					myLabel.textAlignment = .center
				case ".justified":
					myLabel.textAlignment = .justified
				default:
					myLabel.textAlignment = .natural
				}

				myView.addSubview(myLabel)
			}
		}

		NSLog("DONE")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
