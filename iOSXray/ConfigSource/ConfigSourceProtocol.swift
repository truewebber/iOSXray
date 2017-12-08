import Foundation

protocol ConfigSource {
	var remoteConfig: Config? { set get }
	var cacheConfig: Config? { set get }

	func IsRemoteConfigChanged() -> (Bool, Error?)

	func ReadRemoteConfig() -> (Config?, Error?)

	func ReadLocalConfig() -> (Config?, Error?)
}

extension ConfigSource {
	func DecodeConfig(data: Data) -> (Config?, Error?) {
		var config: Config?

		do {
			config = try JSONDecoder().decode(Config.self, from: data)
		} catch {
			NSLog("Error deserialization JSON: \(error)")
			return (nil, error)
		}

		return (config, nil)
	}

	func ReadLocalConfig() -> (Config?, Error?) {
		let textFromCache = UserDefaults.standard.string(forKey: StoredConfigKey)
		if textFromCache == nil {
			return (nil, nil)
		}

		let dataFromCache = (textFromCache!).data(using: .utf8)
		if dataFromCache == nil {
			NSLog("Config str is not nil, but decoded to data nil")
			return (nil, nil)
		}

		return self.DecodeConfig(data: dataFromCache!)
	}
}
