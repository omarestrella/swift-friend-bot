//
//  File.swift
//  
//
//  Created by Omar Estrella on 3/19/21.
//

import Foundation
import Sword
import Hydra

enum KarmaError: Error {
  case NotEnoughKarma
  case CannotSendToSelf
}

struct KarmaManager {
  private static var _main: KarmaManager?
  
  static var main: KarmaManager {
    if let main = _main {
      return main
    }
    let main = KarmaManager()
    _main = main
    return main
  }
}

extension KarmaManager {
  func save(_ karma: Karma) -> Promise<Karma> {
    application.database.save(karma: karma)
  }
  
  func getKarma(for userId: Snowflake) -> Promise<Karma?> {
    application.database.getKarma(for: userId)
  }
  
  func addKarma(from: User, to: User, amount: Int) -> Promise<Int> {
    return async({ _ -> Int in
      if from.id == to.id {
        logger.log(.error, message: "Not allowed to give yourself karma")
        throw KarmaError.CannotSendToSelf
      }
      
      let fromKarma = try await(self.ensureKarmaExists(for: from))
      let toKarma = try await(self.ensureKarmaExists(for: to))
      
      if fromKarma.bank < amount {
        logger.log(.error, message: "Not enough karma")
        throw KarmaError.NotEnoughKarma
      }
      
      fromKarma.bank -= amount
      toKarma.karma += amount
      toKarma.bank += amount + 1
      
      try await(zip(self.save(fromKarma), self.save(toKarma)))
      return toKarma.karma
    })
  }
  
  func ensureKarmaExists(for user: User) -> Promise<Karma> {
    return async({ _ -> Karma in
      if let karma = try await(self.getKarma(for: user.id)) {
        return karma
      }
      let karma = Karma(user: user)
      return try await(self.save(karma))
    })
  }
}
