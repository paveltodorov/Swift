func permutations(str:String) -> [String]
{
    var arr:[String] = []
    if str.isEmpty {return  arr}
    if str.characters.count == 1 {return [str] }
    for i in 0..<str.characters.count
     {
       var str1:String = str
       
       var ch = str1.remove(at:str1.index(str1.startIndex, offsetBy: i))
       var subarr:[String] = permutations(str:str1)
       for j in 0..<subarr.count
        {
           subarr[j].insert(ch,at: subarr[j].startIndex)
           arr.append(subarr[j]);
        }
     }
     return arr
}
print(permutations(str:"ABC"))
print(permutations(str:"ABCD"))
