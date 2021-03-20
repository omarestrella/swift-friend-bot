//
//  File.swift
//  
//
//  Created by Omar Estrella on 3/17/21.
//

import Foundation
import FluentKit
import Sword
import Hydra

final class Karma: Model {
  static var schema: String = "karma"

  @ID(key: .id)
  var id: UUID?
  
  @Field(key: "snowflake") var snowflake: UInt64
  @Field(key: "username") var username: String
  @Field(key: "discriminator") var discriminator: String
  @Field(key: "karma") var karma: Int
  @Field(key: "bank") var bank: Int
  
  @Timestamp(key: "created_at", on: .create, format: .iso8601) var createdAt: Date?
  @Timestamp(key: "updated_at", on: .update, format: .iso8601) var updatedAt: Date?
  
  init() {}
  
  init(user: User) {
    guard let username = user.username else {
      fatalError("No username")
    }
    guard let discriminator = user.discriminator else {
      fatalError("No discriminator")
    }
    
    self.username = username
    self.discriminator = discriminator
    
    snowflake = user.id.rawValue
    karma = 0
    bank = 5
  }
}
