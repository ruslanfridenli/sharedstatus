import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var langRaw: String = sharedStore.selectedLang
    @State private var currentPetId: String = sharedStore.currentPetId
    @State private var currentStatusId: String = sharedStore.currentStatusId
    @State private var partnerPetId: String = sharedStore.partnerPetId
    @State private var partnerStatusId: String = sharedStore.partnerStatusId
    @State private var roomCode: String = sharedStore.roomCode
    @State private var inputCode: String = ""
    @State private var copied: Bool = false
    @State private var isSyncing: Bool = false

    private var lang: appLanguage {
        appLanguage(rawValue: langRaw) ?? .de
    }

    private var selectedPet: buddyPet {
        buddyPet.all.first(where: { $0.id == currentPetId }) ?? buddyPet.all[0]
    }

    private var selectedStatus: buddyStatus {
        buddyStatus.all.first(where: { $0.id == currentStatusId }) ?? buddyStatus.all[0]
    }

    private var partnerPet: buddyPet {
        buddyPet.all.first(where: { $0.id == partnerPetId }) ?? buddyPet.all[1]
    }

    private var partnerStatus: buddyStatus {
        buddyStatus.all.first(where: { $0.id == partnerStatusId }) ?? buddyStatus.all[3]
    }

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                // top bar
                HStack {
                    Text("sharedstatus ☁️")
                        .font(.system(.title3, design: .rounded, weight: .semibold))

                    if isSyncing {
                        ProgressView()
                            .scaleEffect(0.7)
                    }

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

                // live dual widget preview
                previewCard

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
        .task {
            await triggerSync()
        }
    }

    // dual preview card (mirrors the medium home screen widget)
    private var previewCard: some View {
        HStack(spacing: 14) {
            // partner side
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    ZStack(alignment: .bottomTrailing) {
                        Text(partnerPet.emoji)
                            .font(.system(size: 36))
                        Text(partnerStatus.badge)
                            .font(.system(size: 15))
                            .offset(x: 4, y: 4)
                    }
                    Spacer()
                    Text(roomCode.isEmpty ? "demo" : (lang == .de ? "lieblingsmensch" : "buddy"))
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.primary.opacity(0.06))
                        .clipShape(Capsule())
                }

                Spacer(minLength: 8)

                Text(partnerStatus.label(for: lang))
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .lineLimit(2)

                Text(partnerPet.name(for: lang))
                    .font(.system(size: 10, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()
                .opacity(0.3)

            // your side
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    ZStack(alignment: .bottomTrailing) {
                        Text(selectedPet.emoji)
                            .font(.system(size: 36))
                        Text(selectedStatus.badge)
                            .font(.system(size: 15))
                            .offset(x: 4, y: 4)
                    }
                    Spacer()
                    Text(lang == .de ? "du" : "you")
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.primary.opacity(0.06))
                        .clipShape(Capsule())
                }

                Spacer(minLength: 8)

                Text(selectedStatus.label(for: lang))
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .lineLimit(2)

                Text(selectedPet.name(for: lang))
                    .font(.system(size: 10, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
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
                HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                Text(lang == .de ? "euer raum-code" : "your room code")
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
                Text(roomCode)
                .font(.system(.headline, design: .monospaced, weight: .semibold))
                }
                Spacer()
                Button {
                Task { await triggerSync() }
                } label: {
                Image(systemName: "arrow.clockwise")
                .font(.system(size: 12, weight: .semibold))
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                }
                .buttonStyle(.plain)
                Button {
                UIPasteboard.general.string = roomCode
                copied = true
                haptic()
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
                Button(action: leaveRoom) {
                Image(systemName: "xmark")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(8)
                .background(Color.secondary.opacity(0.08))
                .clipShape(Circle())
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
                haptic()
                if inputCode.trimmingCharacters(in: .whitespaces).isEmpty {
                let words = ["kafe", "miau", "wolke", "mond", "tee", "fuchs", "bär"]
                let num = Int.random(in: 10...99)
                roomCode = "(words.randomElement()!)-(num)"
                } else {
                roomCode = inputCode.lowercased().trimmingCharacters(in: .whitespaces)
                }
                sharedStore.roomCode = roomCode
                inputCode = ""
                Task { await triggerSync() }
                }
                private func leaveRoom() {
                haptic()
                roomCode = ""
                sharedStore.roomCode = ""
                WidgetCenter.shared.reloadAllTimelines()
                }
                private func toggleLanguage() {
                haptic()
                langRaw = (lang == .de) ? "en" : "de"
                sharedStore.selectedLang = langRaw
                WidgetCenter.shared.reloadAllTimelines()
                }
                private func selectPet(_ pet: buddyPet) {
                haptic()
                currentPetId = pet.id
                sharedStore.currentPetId = pet.id
                WidgetCenter.shared.reloadAllTimelines()
                Task { await triggerSync() }
                }
                private func selectStatus(_ status: buddyStatus) {
                haptic()
                currentStatusId = status.id
                sharedStore.currentStatusId = status.id
                WidgetCenter.shared.reloadAllTimelines()
                Task { await triggerSync() }
                }
                private func triggerSync() async {
                guard !roomCode.isEmpty else { return }
                isSyncing = true
                await supabaseService.shared.syncRoom(code: roomCode)
                partnerPetId = sharedStore.partnerPetId
                partnerStatusId = sharedStore.partnerStatusId
                isSyncing = false
                WidgetCenter.shared.reloadAllTimelines()
                }
                private func haptic() {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
                }
