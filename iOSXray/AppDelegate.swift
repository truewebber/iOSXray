import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate {

	var window: UIWindow?
	var navigationController: UINavigationController?

	var defaults = UserDefaults.standard

	var storedConfig: Config!
	var networkConfig: Config!

	func application(_ application: UIApplication,
	                 didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Custom View Controller
		let viewController: UIViewController = ViewController()
		self.navigationController = UINavigationController()
		if let navigationController = self.navigationController {
			navigationController.delegate = self
			navigationController.setNavigationBarHidden(true, animated: false)
			navigationController.pushViewController(viewController, animated: false)
			self.window = UIWindow(frame: UIScreen.self.main.bounds)
			if let window = self.window {
				window.rootViewController = navigationController
				window.makeKeyAndVisible()
			}
		}

		var jsonNetworkConfig: Data!
		var jsonStoredConfig: Data!

		// get stored config
		let jsonStrCfg = self.defaults.string(forKey: StoredConfigKey)
		if jsonStrCfg != nil {
			jsonStoredConfig = (jsonStrCfg!).data(using: .utf8)
			self.storedConfig = try! JSONDecoder().decode(Config.self, from: jsonStoredConfig)
		}

		// GET CONFIG FROM NETWORK
		var req = URLRequest(url: URL(string: "http://192.168.0.38:8800/config")!)
		req.httpMethod = "GET"

		let task = URLSession.shared.dataTask(with: req as URLRequest) {
			data, response, error in

			if error != nil {
				NSLog("Error make request, %@", error.debugDescription)

				return
			}

			jsonNetworkConfig = data
			self.networkConfig = try! JSONDecoder().decode(Config.self, from: jsonNetworkConfig)
		}
		task.resume()

		if self.networkConfig == nil && self.storedConfig == nil {
			NSLog("Network is unavailable and no stored config.")
			//Alert about connection

			return true
		}

		if self.storedConfig == nil && self.networkConfig != nil {
			NSLog("First start, set new config")
			// set new config

			return true
		}

		if self.storedConfig != nil && self.networkConfig == nil {
			NSLog("Network is unavailable, use old stored config")

			return true
		}

		if self.storedConfig.uniqueConfigHash != self.networkConfig.uniqueConfigHash {
			NSLog("Stored config is not actual, set new config")
			// set new config

			return true
		}

//		let jsonData = jsonString.data(encoding: .utf8)!
//		let jsonString = String(data: jsonNetworkConfig, encoding: .utf8) {
//		self.defaults.set(jsonString, forKey: StoredConfigKey)

//		self.storedConfig = try! decoder.decode(Config.self, from: jsonStoredConfig)
//		self.defaults.set(String(data: jsonNetworkConfig!, encoding: String.Encoding.utf8), forKey: StoredConfigKey)

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state.
		// This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
		// or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
		// Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough
		// application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of
		// applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of
		// the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive.
		// If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate.
		// Save data if appropriate. See also applicationDidEnterBackground:.
	}
}
