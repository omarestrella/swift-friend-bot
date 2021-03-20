import Foundation
import Sword
import Hydra

let logger = Logger()

class Application {
  var database: DatabaseManager
  var discord: Discord?

  var databaseQueue = DispatchQueue(label: "net.bitcreative.friend-bot.database", attributes: .concurrent)
  var discordQueue = DispatchQueue(label: "net.bitcreative.friend-bot.discord", attributes: .concurrent)

  init() {
    database = DatabaseManager()
    database.initialize().then { _ in
      self.discordQueue.schedule {
        self.connect()
      }
    }
  }

  func connect() {
    discord = Discord(database: database)

    if let discord = discord {
      discord.connect()
      
      discord.addHandler(handler: AnyEventHandler(DefaultMessageHandler()))
      discord.addHandler(handler: AnyEventHandler(ReactionHandler()))
    }
  }
}

let application = Application()

RunLoop.main.run()
