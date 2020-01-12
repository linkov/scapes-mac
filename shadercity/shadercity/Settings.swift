import ScreenSaver

class Settings {
  let defaults = Settings.screenSaverDefaults()
    var lastSelectedShaderURL: String {
    get {
        return (defaults.string(forKey: "lastSelectedShaderURL") ?? "3fc43bc1-c758-4e84-bb25-7c668efe3fc9shader.frag")!
    }
    set(value) {
      defaults.set(value, forKey: "lastSelectedShaderURL")
      defaults.synchronize()
    }
  }
    

    func register() {
      let values: [String: Any] = [
        "isTwelveHour": false
      ]
      defaults.register(defaults: values)
    }

  func dateFormat() -> String {
    if defaults.bool(forKey: "isTwelveHour") {
      return "h:mm:ss"
    } else {
      return "HH:mm:ss"
    }
  }


  private static func screenSaverDefaults() -> ScreenSaverDefaults {
    guard let bundleId = Bundle(for: Settings.self).bundleIdentifier else {
      fatalError("Could not find a bundle identifier")
    }

    guard let defaults = ScreenSaverDefaults(forModuleWithName: bundleId) else {
      fatalError("Could not create ScreenSaverDefaults instance")
    }

    return defaults
  }
}
