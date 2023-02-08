//
//  LockscreenWidget.swift
//  LockscreenWidget
//
//  Created by 민채호 on 2022/12/29.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    private let coreDataManager = CoreDataManager.shared
    
    private func getTodayChallenge() -> String {
        let todayChallenge = coreDataManager.getChallengeOf(Date())
        if todayChallenge.count > 0 {
            return todayChallenge[0].content
        } else {
            return I18N.lockPlaceholder
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), challenge: getTodayChallenge())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), challenge: getTodayChallenge())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentTimeZoneDate = Date().currentTimeZoneDate()
        let midnight = Calendar.current.startOfDay(for: currentTimeZoneDate)
        let nextMidnight = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: midnight
        )!
        
        let entry = SimpleEntry(
            date: currentTimeZoneDate,
            challenge: getTodayChallenge()
        )
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let challenge: String
}

struct LockscreenWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        switch widgetFamily {
        case .accessoryRectangular:
            Text(entry.challenge)
                .multilineTextAlignment(.center)
        case .systemSmall:
            Text(entry.challenge)
                .fontWeight(.bold)
                .foregroundColor(.cellLabel)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        case .systemMedium:
            Text(entry.challenge)
                .fontWeight(.bold)
                .foregroundColor(.cellLabel)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        default:
            Text("Not Implemented")
        }
    }
}

@main
struct LockscreenWidget: Widget {
    let kind: String = "LockscreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LockscreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(I18N.lockTitle)
        .description(I18N.lockDesc)
        .supportedFamilies([
            .accessoryRectangular,
            .systemSmall,
            .systemMedium
        ])
    }
}

struct LockscreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        LockscreenWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            challenge: I18N.lockPlaceholder)
        )
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        .previewDisplayName("Rectangular")
        
        LockscreenWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            challenge: I18N.lockPlaceholder)
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDisplayName("Small")
        
        LockscreenWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            challenge: I18N.lockPlaceholder)
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewDisplayName("Medium")
    }
}
