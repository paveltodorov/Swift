protocol Printable  
 {
var protocolVar : Int  { set get }
func print() -> Void
func print2() -> Void
 }
 
class Day  
 {
var something : String = "not implemented"
func getsomething() -> String
  {
  return "not implemented"
  }
init( something : String = "not implemented"  )
  {
   self.something = something
  }
 }
 
class Time : Day, Printable
 {
var hour : Int = 0
var minutes : Int = 0
var seconds : Double = 0
var protocolVar : Int = 0
func getHour() -> Int
  {
  return 0
  }
func print() -> Void
  {
  return 
  }
func print2() -> Void
  {
  return 
  }
init( hour : Int = 0 , minutes : Int = 0 , seconds : Double = 0 , protocolVar : Int = 0  )
  {
   self.hour = hour
   self.minutes = minutes
   self.seconds = seconds
   self.protocolVar = protocolVar
   super.init()
  }
 }
 
class Appointment : Time
 {
var day : Int = 0
func getDay() -> String
  {
  return "not implemented"
  }
func isImpotrant() -> Bool
  {
  return false
  }
init( day : Int = 0  )
  {
   self.day = day
   super.init()
  }
 }
