//
//  File.swift
//  
//
//  Created by Omar Estrella on 3/19/21.
//

import Foundation
import Sword

enum CommandType: String {
  case karma
  case ping
  case help
  case unknown
  
  static func from(string: String) -> CommandType {
    switch string {
    case "/karma":
      return .karma
    case "/help":
      return .help
    case "/ping":
      return .ping
    default:
      return .unknown
    }
  }
}

protocol Command {
  var type: CommandType { get }
  
  func run(_ discord: Discord, _ message: Message)
}

struct CommandManager {
  static var commands: [Command] {
    [UnknownCommand(), PingCommand(), KarmaCommand()]
  }
  
  static func getCommand(message content: String) -> Command {
    let regex = #"^\/(\w+)"#
    if let range = content.range(of: regex, options: .regularExpression) {
      let commandString = String(content[range])
      let type = CommandType.from(string: commandString)
      return commands.first(where: { command in
        command.type == type
      }) ?? UnknownCommand()
    }
    return UnknownCommand()
  }
}
