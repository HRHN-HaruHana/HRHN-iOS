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
            return I18N.challengeWidgetPlaceholder
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

        let currentTimeZoneDate = Date().convertToCurrentTimeZone()
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

struct ChallengeWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        switch widgetFamily {
        case .accessoryRectangular:
            Text(entry.challenge)
                .multilineTextAlignment(.center)
                .foregroundStyle(entry.challenge == I18N.challengeWidgetPlaceholder ? .secondary : .primary)
                .widgetBackground(.clear)
        case .systemSmall:
            Text(entry.challenge)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .foregroundColor(.cellLabel)
                .opacity(entry.challenge == I18N.challengeWidgetPlaceholder
                         ? 0.7
                         : 1)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .widgetBackground(.clear)
        case .systemMedium:
            Text(entry.challenge)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .foregroundColor(.cellLabel)
                .opacity(entry.challenge == I18N.challengeWidgetPlaceholder
                         ? 0.7
                         : 1)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .widgetBackground(.clear)
        default:
            Text("Not Implemented")
                .widgetBackground(.clear)
        }
    }
}

@main
struct ChallengeWidget: Widget {
    let kind: String = "ChallengeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ChallengeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(I18N.challengeWidgetDisplayName)
        .description(I18N.challengeWidgetDesc)
        .supportedFamilies([
            .accessoryRectangular,
            .systemSmall,
            .systemMedium
        ])
    }
}

struct LockscreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            challenge: I18N.challengeWidgetPlaceholder)
        )
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        .previewDisplayName("Rectangular")
        
        ChallengeWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            challenge: I18N.challengeWidgetPlaceholder)
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDisplayName("Small")
        
        ChallengeWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            challenge: I18N.challengeWidgetPlaceholder)
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewDisplayName("Medium")
    }
}

extension View {
    @ViewBuilder func widgetBackground(_ color: Color) -> some View {
        if #available(iOSApplicationExtension 17.0, macOSApplicationExtension 14.0, *) {
            containerBackground(color, for: .widget)
        } else {
            background(color)
        }
    }
}
