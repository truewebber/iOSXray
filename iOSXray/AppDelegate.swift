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

		// get stored config

		var jsonNetworkConfig: Data!
		var jsonStoredConfig: Data!

		// GET CONFIG FROM NETWORK
		var request = URLRequest(url: URL(string: "http://192.168.0.38:8800/config")!)
		request.httpMethod = "GET"
		let (data, _, error) = URLSession.shared.sendSynchronousRequest(request: request)
		if error != nil {
			NSLog("FUCKING NETWORK ERROR: %@", error.debugDescription)

			return true
		}

		jsonNetworkConfig = data
		// let jsonData = jsonString.data(encoding: .utf8)!
		let decoder = JSONDecoder()
		self.networkConfig = try! decoder.decode(Config.self, from: jsonNetworkConfig)

		// GET CONFIG FROM CACHE
		let jsonStrCfg = self.defaults.string(forKey: StoredConfigKey)
		if jsonStrCfg == nil {
			NSLog("No cached config")
			if jsonNetworkConfig == nil {
				NSLog("No network config")
			}

			if let jsonString = String(data: jsonNetworkConfig, encoding: .utf8) {
				self.defaults.set(jsonString, forKey: StoredConfigKey)
			}

			return true
		}
		jsonStoredConfig = (jsonStrCfg!).data(using: .utf8)

		self.storedConfig = try! decoder.decode(Config.self, from: jsonStoredConfig)

		if self.networkConfig.uniqueConfigHash == self.storedConfig.uniqueConfigHash {
			NSLog("Config is actual")

			return true
		}

		NSLog("New config cached")
		self.defaults.set(String(data: jsonNetworkConfig!, encoding: String.Encoding.utf8), forKey: StoredConfigKey)

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

extension URLSession {
	func sendSynchronousRequest(request: URLRequest) -> (Data?, URLResponse?, Error?) {
		var rData: Data?
		var rResponse: URLResponse?
		var rError: Error?

		let semaphore = DispatchSemaphore(value: 0)

		let task = self.dataTask(with: request) {
			data, response, error in
			rData = data
			rResponse = response
			rError = error

		}
		task.resume()

		_ = semaphore.wait(timeout: .distantFuture)

		return (rData, rResponse, rError)
	}

//	func sendAsynchronousRequest(request: URLRequest) -> (Data?, URLResponse?, Error?) -> URLSessionDataTask {
//		let task = self.dataTask(with: request) {
//			data, response, error in
//
//
//		}
//		task.resume()
//
//		return task
//	}
}

