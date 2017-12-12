import Foundation

class ConfigFactory {
	var artifact: ConfigSource

	init(artifact: ConfigSource) {
		self.artifact = artifact
	}

	func GetConfig() -> (Config?, Error?) {
		let (needDownloadNewConfig, error) = artifact.IsRemoteConfigChanged()
		if error != nil {
			return (nil, error)
		}

		if needDownloadNewConfig {
			return artifact.ReadRemoteConfig()
		}

		return (artifact.cacheConfig, nil)
	}
}
