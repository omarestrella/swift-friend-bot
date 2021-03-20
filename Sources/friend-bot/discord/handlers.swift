//
//  File.swift
//  
//
//  Created by Omar Estrella on 3/17/21.
//

import Foundation
import Hydra
import Sword

typealias ReactionEventData = (GuildChannel, UserID, MessageID, Emoji)

protocol EventHandler {
  associatedtype EventData
  
  var event: Event { get }
  func perform(_ discord: Discord, data: EventData)
}


// Phew...
// https://www.youtube.com/watch?v=XWoNjiSPqI8
// https://leekahseng.medium.com/accomplishing-dynamic-dispatch-on-pats-protocol-with-associated-types-b29d1242e939
struct AnyEventHandler: EventHandler {
  private let performer: (_: Discord, _: Any) -> Void
  
  var event: Event
  
  init<T: EventHandler>(_ eventHandler: T) {
    event = eventHandler.event
    performer = { discord, data in
      guard let data = data as? T.EventData else {
        debugPrint("Error handling AnyEventHandler")
        return
      }
      eventHandler.perform(discord, data: data)
    }
  }
  
  func perform(_ discord: Discord, data: Any) {
    performer(discord, data)
  }
}
