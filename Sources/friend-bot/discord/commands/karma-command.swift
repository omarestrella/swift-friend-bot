//
//  File.swift
//
//
//  Created by Omar Estrella on 3/19/21.
//

import Foundation
import Sword
import Hydra

struct KarmaCommand: Command {
  var type: CommandType {
    .karma
  }

  func run(_ discord: Discord, _ message: Message) {
    if let mention = message.mentions.first {
      KarmaManager.main.getKarma(for: mention.id).then { karma in
        guard let karma = karma else { return }
        discord.send(message: "\(karma.username) has \(karma.karma) karma and \(karma.bank) in the bank", to: message.channel)
      }
    }
  }
}
