//
//  SimpleWidget.swift
//  SimpleWidget
//
//  Created by 城島一輝 on 2020/09/27.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Provider: TimelineProvider {
    // ウィジェットが何を表示するかについて一般的な考えをユーザに提供するべき
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    // 表示するSnapshotを定義
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        // Widgetgalleryに表示されている。
//        if context.isPreview {
//        }
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    // 実際にタイムラインを定義
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // 現在の時間から開始して、1時間おきに切り替わる5つのEntryで構成されるタイムラインを生成
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        // 配列に含めてTimelineにする
        // policy: .atEnd タイムライン終了後新しいタイムラインを要求するポリシー
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}



//struct SimpleWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        Text(entry.date, style: .time)
//    }
//}

@main
struct SimpleWidExt: Widget {
    let kind: String = "SimpleWidExt"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in //SwiftUIのViewを含むクロージャー、ProviderからTimelineEntryパラメーターが渡される
            SimpleWidgetEntryView(entry: entry)
        }
        // Widgetギャラリー（設定画面）にてユーザに表示するタイトル
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct SimpleWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            HStack {
                Text(entry.date, style: .time)
                Image("xxxx")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
        case .systemMedium:
            HStack {
                Image("xxxx")
                    .resizable()
                    .frame(maxWidth: .infinity + 40, maxHeight: .infinity)
                Text(entry.date, style: .time)
            }
        case .systemLarge:
            HStack {
                Text(entry.date, style: .time)
                Image("xxxx")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        default: Text("Default")
        }
    }
}

struct SmallSimpleWidget_Previews: PreviewProvider {
    static var contentView: some View {
        SimpleWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
    
    static var previews: some View {
        Group {
            contentView
                .previewLayout(.fixed(width: 329.0, height: 345.0))
        }
    }
}

struct MediumSimpleWidget_Previews: PreviewProvider {
    static var contentView: some View {
        SimpleWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }

    static var previews: some View {
        Group {
            contentView
                .previewLayout(.fixed(width: 329.0, height: 155.0))
        }
    }
}

struct LargeSimpleWidget_Previews: PreviewProvider {
    static var contentView: some View {
        SimpleWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }

    static var previews: some View {
        Group {
            contentView
                .previewLayout(.fixed(width: 329.0, height: 345.0))
        }
    }
}
