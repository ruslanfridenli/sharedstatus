import Foundation

enum appLanguage: String, CaseIterable {
    case de = "de"
    case en = "en"
}

struct buddyStatus: Identifiable, Codable, Equatable {
    let id: String
    let icon: String
    let textDe: String
    let textEn: String

    func label(for lang: appLanguage) -> String {
        lang == .de ? textDe : textEn
    }

    static let all: [buddyStatus] = [
        buddyStatus(id: "focus", icon: "🐱", textDe: "am arbeiten", textEn: "focusing"),
        buddyStatus(id: "transit", icon: "🚃", textDe: "unterwegs", textEn: "on my way"),
        buddyStatus(id: "coffee", icon: "☕️", textDe: "lust auf kaffee?", textEn: "up for coffee?"),
        buddyStatus(id: "tired", icon: "🫠", textDe: "akku leer", textEn: "low battery"),
        buddyStatus(id: "home", icon: "🛋️", textDe: "zuhause & chill", textEn: "chilling at home"),
        buddyStatus(id: "miss", icon: "🤍", textDe: "denk an dich", textEn: "thinking of you")
    ]
}
