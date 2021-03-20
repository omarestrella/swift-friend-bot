//
//  File.swift
//  
//
//  Created by Omar Estrella on 3/18/21.
//

import Foundation
import Puppy


struct Formatter: LogFormattable {
  func formatMessage(_ level: LogLevel, message: String, tag: String, function: String, file: String, line: UInt, swiftLogInfo: [String: String], label: String, date: Date, threadID: UInt64) -> String {
    let date = dateFormatter(date)
    let file = shortFileName(file)
    return "\(date) \(threadID) [\(level.emoji) \(level)] \(file)#L.\(line) \(function) \(message)"
  }
}

struct Logger {
  private var console: ConsoleLogger
  private var file: FileLogger?
  
  private var puppy = Puppy()
  private var formatter = Formatter()
  
  init() {
    self.console = ConsoleLogger("net.bitcreative.friend-bot")
    console.format = formatter
    puppy.add(console, withLevel: .debug)
    
    do {
      let url = Bundle.main.bundleURL.appendingPathComponent("console.log")
      let file = try FileLogger("net.bitcreative.friend-bot", fileURL: url)
      file.format = formatter
      puppy.add(file, withLevel: .warning)
      
      self.file = file
    } catch {}
  }
  
  @inlinable
  func log(_ level: LogLevel, message: @autoclosure () -> String, tag: String = "", function: String = #function, file: String = #file, line: UInt = #line) {
    switch level {
    case .info:
      puppy.info(message(), tag: tag, function: function, file: file, line: line)
    case .warning:
      puppy.warning(message(), tag: tag, function: function, file: file, line: line)
    case .error:
      puppy.error(message(), tag: tag, function: function, file: file, line: line)
    default:
      puppy.debug(message(), tag: tag, function: function, file: file, line: line)
    }
  }
}
