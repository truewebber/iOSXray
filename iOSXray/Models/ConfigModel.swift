import Foundation

var StoredConfigKey = "stored::config"

struct Config: Codable {
	var apiVersion: Int
	var authorization: String
	var configVersion: Int
	var uniqueConfigHash: String
	var initScreen: String
	var screens: [Screen]

	private enum CodingKeys: String, CodingKey {
		case apiVersion = "api_version", authorization = "authorization", configVersion = "config_version",
		     uniqueConfigHash = "unique_config_hash", initScreen = "init_screen", screens = "screens"
	}

	struct Screen: Codable {
		var screenId: String
		var bgColor: Color
		var views: [View]

		private enum CodingKeys: String, CodingKey {
			case screenId = "screen_id", bgColor = "bg_color", views = "views"
		}
	}
}

struct View: Codable {
	var height: Int
	var width: Int
	var posX: Int
	var posY: Int
	var bgColor: Color
	var onClick: OnClick!
	var views: [View]
	var labels: [Label]

	private enum CodingKeys: String, CodingKey {
		case height = "height", width = "width", posX = "pos_x", posY = "pos_y",
		     bgColor = "bg_color", onClick = "on_click", views = "views", labels = "labels"
	}
}

struct Label: Codable {
	var height: Int
	var width: Int
	var posX: Int
	var posY: Int
	var align: String
	var color: Color
	var text: String
	var textSize: Float

	private enum CodingKeys: String, CodingKey {
		case height = "height", width = "width", posX = "pos_x", posY = "pos_y",
		     align = "align", color = "color", text = "text", textSize = "text_size"
	}
}

struct OnClick: Codable {
	var Action: String
	var ID: String

	private enum CodingKeys: String, CodingKey {
		case Action = "action", ID = "id"
	}
}

struct Color: Codable {
	var alpha: Float
	var blue: Float
	var green: Float
	var red: Float

	private enum CodingKeys: String, CodingKey {
		case alpha = "alpha", blue = "blue", green = "green", red = "red"
	}
}
