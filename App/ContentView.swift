import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var langRaw: String = sharedStore.selectedLang
    @State private var currentPetId: String = sharedStore.currentPetId
    @State private var currentStatusId: String = sharedStore.currentStatusId
    @State private var roomCode: String = sharedStore.roomCode
    @State private var inputCode: String = ""
    @State private var copied: Bool = false

    private var lang: appLanguage {
        appLanguage(rawValue: langRaw) ?? .de
    }

    private var selectedPet: buddyPet {
        buddyPet.all.first(where: { $0.id == currentPetId }) ?? buddyPet.all
    }

    private var selectedStatus: buddyStatus {
        buddyStatus.all.first(where: { $0.id == currentStatusId }) ?? buddyStatus.all
    }

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                // top bar
                HStack {
                    Text("sharedstatus ☁️")
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                    Spacer()
                    Button(action: toggleLanguage) {
                        Text(lang == .de ? "de / en" : "en / de")
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }

                // live preview card (how your buddy sees you)
                HStack(spacing: 16) {
                    ZStack(alignment: .bottomTrailing) {
                        Text(selectedPet.emoji)
                            .font(.system(size: 46))
                            .padding(12)
                            .background(Color.primary.opacity(0.05))
                            .clipShape(Circle())

                        Text(selectedStatus.badge)
                            .font(.system(size: 20))
                            .padding(4)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(lang == .de ? "dein widget-look" : "your widget look")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundStyle(.secondary)
                        Text(selectedStatus.label(for: lang))
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                        Text(selectedPet.name(for: lang))
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                // room code block
                roomSection

                // pet selector
                VStack(alignment: .leading, spacing: 10) {
                    Text(lang == .de ? "wähle dein tierchen" : "pick your little buddy")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundStyle(.secondary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(buddyPet.all) { pet in
                                let isSelected = pet.id == currentPetId
                                Button {
                                    selectPet(pet)
                                } label: {
                                    VStack(spacing: 6) {
                                        Text(pet.emoji)
                                            .font(.system(size: 28))
                                        Text(pet.name(for: lang))
                                            .font(.system(size: 11, design: .rounded, weight: .medium))
                                            .foregroundStyle(.primary)
                                    }
                                    .frame(width: 78, height: 74)
                                    .background(isSelected ? Color.primary.opacity(0.09) : Color.secondary.opacity(0.05))
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                                            .stroke(isSelected ? Color.primary.opacity(0.3) : Color.clear, lineWidth: 1.5)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                // status grid
                VStack(alignment: .leading, spacing: 10) {
                    Text(lang == .de ? "wie ist dein vibe?" : "what's your vibe?")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(buddyStatus.all) { item in
                            let isSelected = item.id == currentStatusId
                            Button {
                                selectStatus(item)
                            } label: {
                                VStack(spacing: 8) {
                                    Text(item.badge)
                                        .font(.system(size: 30))
                                    Text(item.label(for: lang))
                                        .font(.system(.footnote, design: .rounded, weight: .medium))
                                        .foregroundStyle(.primary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(isSelected ? Color.primary.opacity(0.09) : Color.secondary.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(isSelected ? Color.primary.opacity(0.3) : Color.clear, lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(20)
        }
    }

    @ViewBuilder
    private var roomSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if roomCode.isEmpty {
                Text(lang == .de ? "verbinde dich mit deinem lieblingsmenschen" : "connect with your favorite person")
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(.secondary)

                HStack(spacing: 10) {
                    TextField(lang == .de ? "code eingeben..." : "enter code...", text: $inputCode)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .font(.system(.subheadline, design: .rounded))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.secondary.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    Button(action: joinOrCreateRoom) {
                        Text(inputCode.isEmpty ? (lang == .de ? "neu" : "new") : "ok")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.primary)
                            .foregroundStyle(Color(UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            } else {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(lang == .de ? "euer raum-code" : "your room code")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundStyle(.secondary)
                        Text(roomCode)
                            .font(.system(.headline, design: .monospaced, weight: .semibold))
                    }
                    Spacer()
                    Button {
                        UIPasteboard.general.string = roomCode
                        copied = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { copied = false }
                    } label: {
                        Text(copied ? (lang == .de ? "kopiert ✓" : "copied ✓") : (lang == .de ? "kopieren" : "copy"))
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                            }
                            }
                            }
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            }
                            private func joinOrCreateRoom() {
                            if inputCode.trimmingCharacters(in: .whitespaces).isEmpty {
                            let words = ["kafe", "miau", "wolke", "mond", "tee", "fuchs", "bär"]
                            let num = Int.random(in: 10...99)
                            roomCode = "(words.randomElement()!)-(num)"
                            } else {
                            roomCode = inputCode.lowercased().trimmingCharacters(in: .whitespaces)
                            }
                            sharedStore.roomCode = roomCode
                            }
                            private func toggleLanguage() {
                            langRaw = (lang == .de) ? "en" : "de"
                            sharedStore.selectedLang = langRaw
                            WidgetCenter.shared.reloadAllTimelines()
                            }
                            private func selectPet(_ pet: buddyPet) {
                            currentPetId = pet.id
                            sharedStore.currentPetId = pet.id
                            WidgetCenter.shared.reloadAllTimelines()
                            }
                            private func selectStatus(_ status: buddyStatus) {
                            currentStatusId = status.id
                            sharedStore.currentStatusId = status.id
                            WidgetCenter.shared.reloadAllTimelines()
                            }
                            }
