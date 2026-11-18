import Foundation

struct sharedStore {
    static let suiteName = "group.com.sharedstatus.app"

    static var defaults: UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }

    static var currentPetId: String {
        get { defaults.string(forKey: "currentPetId") ?? "cat" }
        set { defaults.set(newValue, forKey: "currentPetId") }
    }

    static var currentStatusId: String {
        get { defaults.string(forKey: "currentStatusId") ?? "home" }
        set { defaults.set(newValue, forKey: "currentStatusId") }
    }

    static var partnerPetId: String {
        get { defaults.string(forKey: "partnerPetId") ?? "fox" }
        set { defaults.set(newValue, forKey: "partnerPetId") }
    }

    static var partnerStatusId: String {
        get { defaults.string(forKey: "partnerStatusId") ?? "coffee" }
        set { defaults.set(newValue, forKey: "partnerStatusId") }
    }

    static var selectedLang: String {
        get { defaults.string(forKey: "selectedLang") ?? "de" }
        set { defaults.set(newValue, forKey: "selectedLang") }
    }

    static var roomCode: String {
        get { defaults.string(forKey: "roomCode") ?? "" }
        set { defaults.set(newValue, forKey: "roomCode") }
    }
}
