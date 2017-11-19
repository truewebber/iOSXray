import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate {

	var window: UIWindow?
	var navigationController: UINavigationController?

	var defaults = UserDefaults.standard
	var ApplicationConfig: Config!

	func application(_ application: UIApplication,
	                 didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

//		let domain = Bundle.main.bundleIdentifier!
//		self.defaults.removePersistentDomain(forName: domain)
//		self.defaults.synchronize()
//		print(Array(self.defaults.dictionaryRepresentation().keys).count)

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

		var networkConfig: Config!
		var storedConfig: Config!

		// get stored config
		let jsonStrCfg = self.defaults.string(forKey: StoredConfigKey)
		if jsonStrCfg != nil {
			jsonStoredConfig = (jsonStrCfg!).data(using: .utf8)

			do {
				storedConfig = try JSONDecoder().decode(Config.self, from: jsonStoredConfig)
			} catch {}
		}

		let myGroup = DispatchGroup()
		myGroup.enter()

		//create session without caches
		let config = URLSessionConfiguration.default
		config.requestCachePolicy = .reloadIgnoringLocalCacheData
		config.urlCache = nil

		let session = URLSession.init(configuration: config)

		// GET CONFIG FROM NETWORK
		var req = URLRequest(url: URL(string: "http://xray.truewebber.com/config.json")!)
		req.httpMethod = "GET"

		let task = session.dataTask(with: req as URLRequest) {
			data, response, error in

			if error != nil {
				NSLog("Error make request, %@", error.debugDescription)
				myGroup.leave()

				return
			}

			jsonNetworkConfig = data
			do {
				networkConfig = try JSONDecoder().decode(Config.self, from: jsonNetworkConfig)
			} catch {
				NSLog("Error deserializing JSON: \(error)")
			}

			myGroup.leave()
		}
		task.resume()

		myGroup.wait()

		if networkConfig == nil && storedConfig == nil {
			NSLog("Network is unavailable and no stored config.")

			return true
		}

		if storedConfig == nil && networkConfig != nil {
			NSLog("First start, set new config")

			// set new config
			self.cacheNewConfig(cfg: jsonNetworkConfig)

			// config
			self.ApplicationConfig = networkConfig

			return true
		}

		if storedConfig != nil && networkConfig == nil {
			NSLog("Network is unavailable, use old stored config")

			// config
			self.ApplicationConfig = storedConfig

			return true
		}

		if storedConfig.uniqueConfigHash != networkConfig.uniqueConfigHash {
			NSLog("Stored config is not actual, set new config")

			// set new config
			self.cacheNewConfig(cfg: jsonNetworkConfig)

			// config
			self.ApplicationConfig = networkConfig

			return true
		}

		self.ApplicationConfig = storedConfig
		NSLog("Stored config is actual")

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

	func cacheNewConfig(cfg: Data!) {
		self.defaults.set(String(data: cfg!, encoding: String.Encoding.utf8), forKey: StoredConfigKey)
	}
}
