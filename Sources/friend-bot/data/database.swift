//
//  File.swift
//
//
//  Created by Omar Estrella on 3/17/21.
//

import FluentKit
import FluentSQL
import FluentSQLiteDriver
import Foundation
import Hydra
import Sword

enum DatabaseError: Error {
  case DatabaseFileNotFound
  case NoConnection
  case NotFound
}

func databaseUrl() -> URL? {
  let url = Bundle.main.bundleURL
  return url.appendingPathComponent("db.sqlite")
}

struct DatabaseManager {
  var databases: Databases
  var threadpool: NIOThreadPool
  var eventLoopGroup: MultiThreadedEventLoopGroup
  var migrator: Migrator

  init() {
    threadpool = NIOThreadPool(numberOfThreads: 2)
    eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
    threadpool.start()
    databases = Databases(threadPool: threadpool, on: eventLoopGroup)

    do {
      guard let path = databaseUrl() else {
        throw DatabaseError.DatabaseFileNotFound
      }
      let config: SQLiteConfiguration = .file(path.absoluteString)

      logger.log(.debug, message: "Using database: \(path)")

      databases.use(.sqlite(config), as: .sqlite)
    } catch {
      print("Error loading database. Using in-memory database: \(error)")
      databases.use(.sqlite(.memory), as: .sqlite)
    }

    databases.default(to: .sqlite)

    let migrations = Migrations()
    migrations.add([
      CreateTablesMigration()
    ])
    migrator = Migrator(databases: databases, migrations: migrations, logger: .init(label: "database.migrator"), on: eventLoopGroup.next())
  }

  var database: FluentKit.Database? {
    databases.database(logger: .init(label: "database"), on: eventLoopGroup.next())
  }

  func initialize() -> Promise<Void> {
    do {
      try migrator.setupIfNeeded().wait()
      try migrate()
      return Promise(resolved: ())
    } catch {
      return Promise(rejected: error)
    }
  }

  private func migrate() throws {
    let migrations = try migrator.previewPrepareBatch().wait()
    guard migrations.count > 0 else {
      print("No new migrations.")
      return
    }
    print("The following migration(s) will be prepared:")
    let logs = migrations.map { (migration, dbid) -> String in
      let name = dbid?.string ?? "default"
      return "+ \(migration.name) on \(name)"
    }
    print("\(logs.joined(separator: "\n"))")
    try migrator.prepareBatch().wait()
    print("Migration successful")
  }
}

extension DatabaseManager {
  func save(karma: Karma) -> Promise<Karma> {
    guard let db = database else {
      return Promise(rejected: DatabaseError.NoConnection)
    }
    return Promise { resolve, reject, _ in
      do {
        if karma.id != nil {
          try karma.update(on: db).wait()
        } else {
          try karma.save(on: db).wait()
        }
        resolve(karma)
      } catch {
        reject(error)
      }
    }
  }
  
  func getKarma(for userId: Snowflake) -> Promise<Karma?> {
    guard let db = database else {
      return Promise(rejected: DatabaseError.NoConnection)
    }
    
    return Promise { resolve, reject, _ in
      do {
        let karma = try Karma.query(on: db)
          .filter(\.$snowflake == userId.rawValue)
          .first()
          .wait()
        resolve(karma)
      } catch {
        reject(error)
      }
    }
  }
}
