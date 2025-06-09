//
//  CryptoChaserWidgetLiveActivity.swift
//  CryptoChaserWidget
//
//  Created by Ernesto Sánchez Kuri on 09/06/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CryptoChaserWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CryptoChaserWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CryptoChaserWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CryptoChaserWidgetAttributes {
    fileprivate static var preview: CryptoChaserWidgetAttributes {
        CryptoChaserWidgetAttributes(name: "World")
    }
}

extension CryptoChaserWidgetAttributes.ContentState {
    fileprivate static var smiley: CryptoChaserWidgetAttributes.ContentState {
        CryptoChaserWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CryptoChaserWidgetAttributes.ContentState {
         CryptoChaserWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CryptoChaserWidgetAttributes.preview) {
   CryptoChaserWidgetLiveActivity()
} contentStates: {
    CryptoChaserWidgetAttributes.ContentState.smiley
    CryptoChaserWidgetAttributes.ContentState.starEyes
}
