//
//  File.swift
//  
//
//  Created by Omar Estrella on 3/19/21.
//

import Foundation
import Sword

struct UnknownCommand: Command {
  var type: CommandType {
    .unknown
  }
  
  func run(_ discord: Discord, _ message: Message) {
    logger.log(.warning, message: "Unknown Command Attempted")
  }
}
