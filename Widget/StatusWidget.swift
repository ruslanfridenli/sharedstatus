import WidgetKit
import SwiftUI

struct statusEntry: TimelineEntry {
    let date: Date
    let pet: buddyPet
    let status: buddyStatus
    let lang: appLanguage
}

struct statusProvider: TimelineProvider {
    func placeholder(in context: Context) -> statusEntry {
        statusEntry(date: Date(), pet: buddyPet.all, status: buddyStatus.all, lang: .de)
    }

    func getSnapshot(in context: Context, completion: @escaping (statusEntry) -> ()) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<statusEntry>) -> ()) {
        let entry = loadEntry()
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func loadEntry() -> statusEntry {
        let petId = sharedStore.currentPetId
        let statusId = sharedStore.currentStatusId
        let langRaw = sharedStore.selectedLang

        let pet = buddyPet.all.first(where: { $0.id == petId }) ?? buddyPet.all
        let status = buddyStatus.all.first(where: { $0.id == statusId }) ?? buddyStatus.all
        let lang = appLanguage(rawValue: langRaw) ?? .de

        return statusEntry(date: Date(), pet: pet, status: status, lang: lang)
    }
}

struct statusWidgetEntryView: View {
    var entry: statusProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                ZStack(alignment: .bottomTrailing) {
                    Text(entry.pet.emoji)
                        .font(.system(size: 38))
                        .widgetAccentable()

                    Text(entry.status.badge)
                        .font(.system(size: 16))
                        .offset(x: 4, y: 4)
                }

                Spacer()

                Text("live")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Capsule())
            }

            Spacer()

            Text(entry.status.label(for: entry.lang))
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .widgetAccentable()

            Text(entry.lang == .de ? "gerade eben" : "just now")
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(4)
        .containerBackground(.ultraThinMaterial, for: .widget)
    }
}

@main
struct statusWidget: Widget {
    let kind: String = "statusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: statusProvider()) { entry in
            statusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("sharedstatus")
        .description("cozy buddy status widget for your home screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
