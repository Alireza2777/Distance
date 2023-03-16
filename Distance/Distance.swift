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
  //Constants for ease of checking----
  private static let MAXYARDS = 1760
  private static let MAXFEET = 3
  private static let MAXINCHES = 12
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
  init?() {
          mile = 0
          yard = 0
          foot = 0
          inches = 0
      }
  private var totalInches: Int {
    return mile * 1760 * 3 * 12 + yard * 3 * 12 + foot * 12 + inches
  }
  static func <(lhs: Distance, rhs: Distance) -> Bool {
         if lhs.mile < rhs.mile { //If miles are smaller it will always be smaller
             return true
         } else if lhs.mile > rhs.mile { //If miles are larger it will always be larger
             return false
         }
         //If it's not smaller or larger then it's equal and we continue to next unit
         if lhs.yard < rhs.yard { //If yards are smaller...
             return true
         } else if lhs.yard > rhs.yard { //If yards are larger...
             return false
         }
         //If it's not smaller or larger then it's equal and we continue to next unit
         if lhs.foot < rhs.foot { //If feet are smaller...
             return true
         } else if lhs.foot > rhs.foot { //If feet are larger...
             return false
         }
         //If it's not smaller or larger then it's equal and we continue to next unit
         if lhs.inches < rhs.inches { //If inches are smaller...
             return true
         } else { //If this last unit is not smaller then the distance is not smaller
             return false
         }
     }
  private static func simplify(_ distance: Distance) -> Distance {
         //Unwrap the new distance
         if let sim = Distance(mile: distance.mile, yards: distance.yard, feet: distance.foot, inches: distance.inches) {
             return sim
         } else { //If invalid return a distance of 0
             return Distance()!
         }
     }
  static func +(lhs: Distance, rhs: Distance) -> Distance {
          if let answer = Distance(miles: lhs.mile + rhs.mile, yards: lhs.yard + rhs.yard, feet: lhs.foot + rhs.foot, inches: lhs.inches + rhs.inches) {
              return answer
          }
          return Distance()!
      }
  static func -(lhs: Distance, rhs: Distance) -> Distance? {
          if lhs.mile >= rhs.mile { //Check that the first distance is not smaller than the second one
              //Variables in order to do the substraction of values in case one of the variables from second distance is larger than its counterpart
              var m = lhs.mile //The value being subtracted
              var subM = rhs.mile //How much we substract
              var y = lhs.yard //The value being subtracted
              var subY = rhs.yard //How much we substract
              var f = lhs.foot //The value being subtracted
              var subF = rhs.foot //How much we substract
              var i = lhs.inches //The value being subtracted
              var subI = rhs.inches //How much we substract
              
              //Do the operations to get any extra substraction from the feet
              while subI > 0 { //While there are still inches to substract
                  if subI > i { //If we substract more than we have
                      subF += 1 //We substract more from the next bigger unit
                      subI -= i
                      i = MAXINCHES //Set value at max to keep substracting
                  } else { //If we can substract enough we just reduce the numbers
                      i -= subI //Substract the value
                      subI = 0
                  }
              }
              //Repeat the steps above for the different units
              while subF > 0 {
                  if subF > f {
                      subY += 1
                      subF -= f
                      f = MAXFEET
                  } else {
                      f -= subF
                      subF = 0
                  }
              }
              //Repeat the steps above for the different units
              while subY > 0 {
                  if subY > y {
                      subM += 1
                      subY -= y
                      y = MAXYARDS
                  } else {
                      y -= subY
                      subY = 0
                  }
              }
              
              m -= subM //Set the value of the miles
              if let answer = Distance(mile: m, yard: y, foot: f, inches: i) { //Unwrap the new distance and make sure its formatted
                  return answer
              } else {
                  return Distance()!
              }
          } else { //If first distance is smaller than second return nil
              return nil
          }
    //Method to add inches to distance
        func += (lhs:Distance, rhs: Int) {
            lhs.inches = lhs.inches + rhs //Add the inches
            let sim = Distance.simplify(lhs) //Reformat the values
            //Set the new values to the instance
            lhs.inches = sim.inches
            lhs.foot = sim.foot
            lhs.yard = sim.yard
            lhs.mile = sim.mile
        }
      }
}
