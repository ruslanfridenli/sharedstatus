import Foundation

enum appLanguage: String, CaseIterable {
    case de = "de"
    case en = "en"
}

struct buddyPet: Identifiable, Codable, Equatable {
    let id: String
    let emoji: String
    let nameDe: String
    let nameEn: String

    func name(for lang: appLanguage) -> String {
        lang == .de ? nameDe : nameEn
    }

    static let all: [buddyPet] = [
        buddyPet(id: "cat", emoji: "🐱", nameDe: "kätzchen", nameEn: "kitty"),
        buddyPet(id: "fox", emoji: "🦊", nameDe: "füchschen", nameEn: "little fox"),
        buddyPet(id: "bear", emoji: "🐻‍❄️", nameDe: "eisbär", nameEn: "polar bear"),
        buddyPet(id: "bunny", emoji: "🐰", nameDe: "häschen", nameEn: "bunny"),
        buddyPet(id: "frog", emoji: "🐸", nameDe: "fröschlein", nameEn: "froggy"),
        buddyPet(id: "duck", emoji: "🦆", nameDe: "entchen", nameEn: "duckling")
    ]
}

struct buddyStatus: Identifiable, Codable, Equatable {
    let id: String
    let badge: String
    let textDe: String
    let textEn: String

    func label(for lang: appLanguage) -> String {
        lang == .de ? textDe : textEn
    }

    static let all: [buddyStatus] = [
        buddyStatus(id: "home", badge: "🛋️", textDe: "zuhause & chill", textEn: "chilling at home"),
        buddyStatus(id: "focus", badge: "💻", textDe: "am arbeiten", textEn: "focusing"),
        buddyStatus(id: "transit", badge: "🚃", textDe: "unterwegs", textEn: "on my way"),
        buddyStatus(id: "coffee", badge: "☕️", textDe: "lust auf kaffee?", textEn: "up for coffee?"),
        buddyStatus(id: "tired", badge: "🪫", textDe: "akku leer", textEn: "low battery"),
        buddyStatus(id: "miss", badge: "🤍", textDe: "denk an dich", textEn: "thinking of you")
    ]
}
# project sharedstatus
