//
//  File.swift
//
//
//  Created by Omar Estrella on 3/16/21.
//

import Foundation
import Sword
import Hydra

let token = ProcessInfo.processInfo.environment["DISCORD_TOKEN"] ?? ""
let owners = ["103301979987537920"]

typealias UserID = Snowflake
typealias MessageID = Snowflake

enum DiscordError: Error {
  case NoConnection
  case BadRequest(_ description: String?)
}

class Discord {
  private var connection: Sword?
  
  var database: DatabaseManager
  
  init(database: DatabaseManager) {
    self.database = database
  }
  
  var connected: Bool {
    connection != nil
  }
  
  func connect() {
    connection = Sword(token: token)
    
    guard let connection = connection else {
      return
    }
    
    connection.on(.ready) { _ in
      logger.log(.info, message: "Connected")
    }
    connection.on(.disconnect) { _ in
      logger.log(.info, message: "Disconnected")
      
      self.connection = nil
    }
    
    connection.connect()
  }
  
  func addHandler(handler: AnyEventHandler) {
    guard let connection = connection else {
      return
    }
    
    connection.on(handler.event) { data in
      handler.perform(self, data: data)
    }
  }
  
  func send(message: String, to channel: Channel) {
    guard let connection = connection else {
      return
    }
    connection.send(message, to: channel.id)
  }
  
  func getMessage(_ id: Snowflake, in channel: Snowflake) -> Promise<Message> {
    guard let connection = connection else {
      return Promise(rejected: DiscordError.NoConnection)
    }
    return Promise { resolve, reject, _ in
      connection.getMessage(id, from: channel) { message, error in
        if let message = message {
          resolve(message)
          return
        }
        if let error = error {
          debugPrint("Error during message fetch")
          reject(error)
          return
        }
        reject(DiscordError.BadRequest("getMessage"))
      }
    }
  }
  
  func getUser(_ id: Snowflake) -> Promise<User> {
    guard let connection = connection else {
      return Promise(rejected: DiscordError.NoConnection)
    }
    return Promise { resolve, reject, _ in
      connection.getUser(id) { user, error in
        if let user = user {
          resolve(user)
          return
        }
        if let error = error {
          debugPrint("Error during user fetch")
          reject(error)
          return
        }
        reject(DiscordError.BadRequest("getUser"))
      }
    }
  }
}
