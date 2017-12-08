import Foundation

class RemoteServerStorageConfig: ConfigSource {
	var defaults = UserDefaults.standard

	var remoteConfig: Config?
	var cacheConfig: Config?

	func IsRemoteConfigChanged() -> (Bool, Error?) {
		if self.cacheConfig == nil {
			let (config, error) = self.ReadRemoteConfig()
			if error != nil {
				NSLog("Error read config from cache: \(error.debugDescription)")
				return (false, error)
			}

			if config == nil {
				return (true, nil)
			}

			self.remoteConfig = config
		}

		var remoteHash: String = ""
		//HTTP HEAD Request
		remoteHash = "blya"


		if remoteHash != self.cacheConfig?.uniqueConfigHash {
			return (true, nil)
		}

		return (false, nil)
	}

	func ReadRemoteConfig() -> (Config?, Error?) {
		//HTTP GET Request

		let textFromFile = "bla bla json text must be here"
		let dataFromFile = (textFromFile).data(using: .utf8)
		if dataFromFile == nil {
			NSLog("Config str is not nil, but decoded to data nil")
			return (nil, nil)
		}

		return self.DecodeConfig(data: dataFromFile!)
	}
}

