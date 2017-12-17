import Foundation

class ConfigFactory {
	var artifact: ConfigSource

	init(artifact: ConfigSource) {
		self.artifact = artifact
	}

	func GetConfig() -> (Config?, Error?) {
		let (needDownloadNewConfig, error) = artifact.IsRemoteConfigChanged()
		if error != nil {
			if artifact.cacheConfig != nil {
				return (artifact.cacheConfig, nil)
			}

			return (nil, error)
		}

		if needDownloadNewConfig {
			NSLog("remote")

			return artifact.ReadRemoteConfig()
		}

		NSLog("local")

		return artifact.ReadLocalConfig()
	}
}
