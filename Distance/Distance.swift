//
//  Distance.swift
//  Distance
//
//  Created by Alireza Karimi on 2023-03-13.
//

import Foundation

class Distance : CustomStringConvertible {
  var description: String {
    "\(mile)m \(yard)y \(foot)' \(inches)\" "
    if mile == 0 && yard == 0 && foot == 0 && inches == 0 {
      return "0\" "
    }
    var m = mile > 0 ? "\(mile)m " : ""
    var y = yard > 0 ? "\(yard)y " : ""
    var f = foot > 0 ? "\(foot)' " : ""
    var i = inches > 0 ? "\(inches)\" " : ""
    return "(\(m)\(y)\(f)\(i))"
  }
  private var inches : Int = 0
  private var foot : Int = 0
  private var yard : Int = 0
  private var mile : Int = 0
  init?(mile: Int, yard: Int, foot: Int, inches: Int) {
    var counterfoot = 0
    var counteryard = 0
    var countermile = 0
    if inches < 12 && inches >= 0 {
      self.inches = inches
    }
    else{
      if inches < 0 {
        return nil
      }
      else{
        counterfoot = inches / 12
        self.inches = inches % 12
      }
    }
    if foot + counterfoot < 3 && foot >= 0 {
      self.foot = foot
    }
    else{
      if foot < 0 {
        return nil
      }
      else{
        counteryard = foot / 3
        self.foot = (foot + counterfoot) % 3
      }
    }
    if yard + counteryard < 1760 && yard >= 0 {
      self.yard = yard
    }
    else{
      if yard < 0 {
        return nil
      }
      else{
        countermile = yard / 1760
        self.yard = (yard + counteryard) % 1760
      }
    }
    if mile > 0{
      self.mile = mile + countermile
    }
    else{
      if mile < 0 {
        return nil
      }
    }
  }
  private var totalInches: Int {
    return mile * 1760 * 3 * 12 + yard * 3 * 12 + foot * 12 + inches
  }
  extension Distance: Equatable, Comparable {
    static func == (lhs: Distance, rhs: Distance) -> Bool {
      return lhs.totalInches == rhs.totalInches
    }
    
    static func < (lhs: Distance, rhs: Distance) -> Bool {
      return lhs.totalInches < rhs.totalInches
    }
  }
  ​
  extension Distance {
    static func +(lhs: Distance, rhs: Distance) -> Distance {
      return Distance(miles: lhs.mile + rhs.mile, yards: lhs.yard + rhs.yard, foot: lhs.foot + rhs.foot, inches: lhs.inches + rhs.inches)!
    }
    
    static func -(lhs: Distance, rhs: Distance) -> Distance? {
      if lhs.totalInches < rhs.totalInches {
        return Distance()
      } else {
        return Distance(mile: lhs.mile - rhs.mile, yard: lhs.yard - rhs.yard, foot: lhs.foot - rhs.foot, inches: lhs.inches - rhs.inches)
      }
    }
    
    static func *(lhs: Distance, rhs: Int) -> Distance {
      return Distance(mile: lhs.mile * rhs, yard: lhs.yard * rhs, foot: lhs.foot * rhs, inches: lhs.inches * rhs)!
    }
    
    static func +=(lhs: Distance, rhs: Int) {
      lhs.inches += rhs
      lhs.simplify()
    }
  }
}
