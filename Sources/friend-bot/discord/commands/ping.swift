//
//  File.swift
//  
//
//  Created by Omar Estrella on 3/19/21.
//

import Foundation
import Sword

struct PingCommand: Command {
  var type: CommandType {
    .ping
  }

  func run(_ discord: Discord, _ message: Message) {
    discord.send(message: "Pong!", to: message.channel)
  }
}
