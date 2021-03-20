//
//  File.swift
//
//
//  Created by Omar Estrella on 3/17/21.
//

import FluentKit
import Foundation

struct CreateTablesMigration: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    let karmaSchema = database.schema(Karma.schema)
      .id()
      .field("snowflake", .int64)
      .field("username", .string)
      .field("discriminator", .string)
      .field("karma", .int)
      .field("bank", .int)
      .field("created_at", .date)
      .field("updated_at", .date)
      .ignoreExisting()
      .create()

    return database.eventLoop.flatten([
      karmaSchema,
    ])
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Karma.schema).delete()
  }
}
