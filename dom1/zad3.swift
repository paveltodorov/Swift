var dx:[Int] = [0,1,0,-1]
var dy:[Int] = [1,0,-1,0]

var arr:[[String]] = [["^","0","0","0","0","0","0","1"],
                      ["0","1","1","1","1","1","0","0"],
                      ["0","0","0","0","0","1","1","1"],
                      ["0","1","1","1","0","1","0","0"],
                      ["0","1","0","1","0","0","0","1"],
                      ["0","0","0","1","0","1","0","*"]]

func findChar(in arr:[[String]],char:String)->(Int,Int)
{
    for i in 0..<arr.count
    {
      for j in 0..<arr[0].count
    {
     if arr[i][j] == char {return (i,j) }    
    }
    }
    return (-1,-1)
}
func findPathBetween(start:(i:Int,j:Int),in arr:inout[[String]],_ visited:inout[(i:Int,j:Int)] ) -> Bool
{
    visited.append(start)
    if start.i < 0 || start.j < 0 {return false}
    if start.i >= arr.count || start.j >= arr[0].count  {return false}
    if arr[start.i][start.j] == "1" {return false}
    if arr[start.i][start.j] == "*"  {return true}
    
    for k in 0..<3
     {
        arr[start.i][start.j] = "1"
        var b:Bool = findPathBetween(start:(i:start.i + dx[k] ,j:start.j + dy[k]) ,in:&arr,&visited)  
        arr[start.i][start.j] = "0"
        if b == true {return true}
        visited.removeLast()
     }
    return false 
}
func findPath(in arr:inout[[String]]) -> [(i:Int,j:Int)]
{
 var start = findChar(in: arr,char:"^")
 var visited:[(i:Int,j:Int)] = []
 var b = findPathBetween(start:start,in:&arr,&visited)
 if b == true
  {return visited}
  return []
 }
print(findPath(in: &arr))
