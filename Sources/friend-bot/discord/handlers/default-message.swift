//
//  File.swift
//  
//
//  Created by Omar Estrella on 3/18/21.
//

import Foundation
import Sword

struct DefaultMessageHandler: EventHandler {
  typealias EventData = Message

  var event = Event.messageCreate

  func perform(_ discord: Discord, data: EventData) {
    let message = data
    guard let sender = message.author else {
      logger.log(.error, message: "Message has no sender")
      return
    }
    let content = message.content
    
    // Check for a command
    if content.starts(with: "/") {
      let command = CommandManager.getCommand(message: content)
      command.run(discord, message)
    }
  }
}
