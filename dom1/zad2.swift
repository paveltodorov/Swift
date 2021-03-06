func evaluate(expression : String) -> Int
{
  var numbers:[Int] = []
  var operations:String = ""
  var num:Int = 0
  var b = false
  for i in 0..<expression.characters.count
  { 
   var ch = expression[expression.index(expression.startIndex, offsetBy: i)]
   if isOperator(str:ch)
    {
     if b 
     {
     numbers.append(num)
     num = 0;
     b = false
     }
     if(ch == ")")
     {
       var op:Character 
       op = operations.remove(at: operations.index(before: operations.endIndex))
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
         num = num*10 + Int(String(ch))! 
         b = true
       }
    }
  }
  if b
  {numbers.append(num)}
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
print(evaluate(expression :"2 + 2*((8 - 5) - 3^2)*8 + 2^3^2 ")) 
