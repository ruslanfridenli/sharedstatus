import Foundation

struct roomRecord: Codable {
    let code: String
    let user_a_id: String?
    let user_a_pet: String?
    let user_a_status: String?
    let user_b_id: String?
    let user_b_pet: String?
    let user_b_status: String?
}

final class supabaseService {
    static let shared = supabaseService()

    // вставь сюда свои данные из supabase -> project settings -> api
    private let supabaseUrl = "https://qosummyejpfobqbqsgru.supabase.co/rest/v1/"
    private let supabaseKey = "sb_publishable_88dsq9wUV1H1Hbu0cbRBeA_xN8fPGjS"

    private func makeRequest(path: String, method: String = "GET", body: [String: Any]? = nil) -> URLRequest? {
        guard let url = URL(string: "\(supabaseUrl)/rest/v1/\(path)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(supabaseKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")

        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        return request
    }

    func syncRoom(code: String) async {
        let myId = sharedStore.deviceId
        guard let getReq = makeRequest(path: "rooms?code=eq.\(code)&select=*") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(for: getReq)
            let rooms = try JSONDecoder().decode([roomRecord].self, from: data)

            if let room = rooms.first {
                if room.user_a_id == myId {
                    sharedStore.partnerPetId = room.user_b_pet ?? "fox"
                    sharedStore.partnerStatusId = room.user_b_status ?? "coffee"
                    await updateMySlot(code: code, slot: "a")
                } else if room.user_b_id == myId || room.user_b_id == nil {
                    sharedStore.partnerPetId = room.user_a_pet ?? "cat"
                    sharedStore.partnerStatusId = room.user_a_status ?? "home"
                    await updateMySlot(code: code, slot: "b")
                }
            } else {
                let payload: [String: Any] = [
                    "code": code,
                    "user_a_id": myId,
                    "user_a_pet": sharedStore.currentPetId,
                    "user_a_status": sharedStore.currentStatusId
                ]
                if let postReq = makeRequest(path: "rooms", method: "POST", body: payload) {
                    _ = try? await URLSession.shared.data(for: postReq)
                }
            }
        } catch {
            print("sync error: \(error)")
        }
    }

    private func updateMySlot(code: String, slot: String) async {
        let payload: [String: Any] = [
            "user_\(slot)_id": sharedStore.deviceId,
            "user_\(slot)_pet": sharedStore.currentPetId,
            "user_\(slot)_status": sharedStore.currentStatusId
        ]
        if let patchReq = makeRequest(path: "rooms?code=eq.\(code)", method: "PATCH", body: payload) {
            _ = try? await URLSession.shared.data(for: patchReq)
        }
    }
}
