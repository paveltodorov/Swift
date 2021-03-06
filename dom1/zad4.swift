class Expression 
{
    var str:String = ""
    init(str:String)
    {
        self.str = str
    }
}
class ReplaceExpression : Expression
{
    var values:[String:Int] = [:]
    init(str:String,values:[String:Int])
    {
        super.init(str:str)
        self.values = values
    }
func evaluate()-> Int
{
  var numbers:[Int] = []
  var operations:String = ""
  var num:Int = 0
  var b = false
  for i in 0..<str.characters.count
  { 
   var ch = str[str.index(str.startIndex, offsetBy: i)]
   if isOperator(str:ch)
    {
     if(ch == ")")
     {
       var op:Character = operations.remove(at: operations.index(before: operations.endIndex))
        while !(op == "(" )
       {
              var a = numbers.remove(at:numbers.count - 1)
              var b = numbers.remove(at:numbers.count - 1)
              var result = execute(a:a,b:b,op:op)
              numbers.append(result)
              op = operations.remove(at: operations.index(before: operations.endIndex))
        }
     }
     else
     {
     while 
          !(operations.isEmpty 
          || priority(operations[operations.index(before: operations.endIndex)]) < priority(ch)
          || (ch == "^" && operations[operations.index(before: operations.endIndex)] == "^")
          || ch == "(")
          {
              var a = numbers.remove(at:numbers.count - 1)
              var b = numbers.remove(at:numbers.count - 1)
              var op = operations.remove(at: operations.index(before: operations.endIndex))
              var result = execute(a:a,b:b,op:op)
              numbers.append(result)
          } 
     operations.insert(ch, at: operations.endIndex)      
    }
    }
    else
    {
     if ch != " "
     {
       numbers.append(values[(String(ch))]!)
     }
    }
  }
 
  while(!(operations.isEmpty ))
  {
       var a = numbers.remove(at:numbers.count - 1)
       var b = numbers.remove(at:numbers.count - 1)
       var op = operations.remove(at: operations.index(before: operations.endIndex))
       var result = execute(a:a,b:b,op:op)
       numbers.append(result)  
  }
  return numbers.remove(at:numbers.count - 1)
}
}
func isOperator(str:Character) -> Bool
{
    return str == "*" || str == "/" || str=="-" || str == "+"
                      || str == "^" || str=="(" || str == ")"
}
func priority(_ str:Character) -> Int 
{
 if str == "^"               {return 2}
 if str == "*" || str == "/" {return 1}
 if str == "+" || str == "-" {return 0}
 return -1
}
func execute(a:Int,b:Int,op:Character) -> Int
{
    switch op
    {
    case "+" : return a + b
    case "-" : return b - a
    case "*" : return a * b
    case "/" : return b / a
    case "^" : return Int(pow(Double(b) ,Double(a)))
    default  : return 0
    }
}
var str = "(a*d - (b - c + a^d) )*d + e^d^d  "
var values  = ["a":5,"b":6,"c":10,"d":2,"e" : 4]
var values1 = ["a":3,"b":-2,"c":9,"d":3,"e" : 4]
var obj = ReplaceExpression(str:str,values:values)
print(obj.evaluate())
var obj1 = ReplaceExpression(str:str,values:values1)
print(obj1.evaluate())
