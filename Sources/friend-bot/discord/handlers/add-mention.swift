//
//  File.swift
//
//
//  Created by Omar Estrella on 3/18/21.
//

import Foundation
import Hydra
import Sword

struct ReactionHandler: EventHandler {
  typealias EventData = ReactionEventData

  var event = Event.reactionAdd

  func perform(_ discord: Discord, data: EventData) {
    let (channel, userId, messageId, _) = data
    zip(discord.getUser(userId), discord.getMessage(messageId, in: channel.id)).then { sender, message -> Void in
      guard let author = message.author, let authorName = author.username else {
        return
      }

      let log = ["Adding mention karma from: \(String(describing: sender.username))",
                 "To: \(authorName)",
                 "In: \(String(describing: channel.name))"].joined(separator: "\n")
      logger.log(.debug, message: log)
      
      KarmaManager.main.addKarma(from: sender, to: author, amount: 1).then { newKarma in
        let message = "\(authorName) now has \(newKarma) karma"
        discord.send(message: message, to: channel)
      }.catch { error in
        logger.log(.error, message: "Reaction error: \(error)")
      }
    }.catch { error in
      logger.log(.error, message: "Reaction error: \(error)")
    }
  }
}
