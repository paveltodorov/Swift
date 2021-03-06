func containsAttribute(attribute:Attribute,arr:[Attribute]) -> Bool
{
	for i in arr
	{
		if attribute.name == i.name
		{
			return true
		}
	}
	return false	
}
func containsFunction(function:Function,arr:[Function]) -> Bool
{
	for i in arr
	{
		if function.name == i.name
		{
			return true
		}
	}
	return false	
}
struct Attribute
{
    var name:String
    var type:String
	var defaultValue:String
    init(name:String = "",type:String = "")
    {
        self.name = name
        self.type = type
		switch(type)
	 {
     case "Int" : defaultValue = "0"
	 case "Double" : defaultValue = "0"
	 case "Bool" : defaultValue = "false"
	 case "String" : defaultValue = "\"not implemented\""	 
	 default :	  defaultValue = ""
	 }
		
    }
	func convert() -> Void
	{
    print("var \(name) : \(type) = \(defaultValue)")		
	}
	func protocolConvert() -> Void
	{
    print("var \(name) : \(type)  { set get }")		
	}
}
struct Function
{
    var name:String
    var body:String
    var type:String
    var parameters:[Attribute]=[]
    init(name:String = "",type:String = "",body:String="",parameters:[Attribute] = [])
    {
        self.name = name
        self.body = body
        self.type = type
        self.parameters = parameters
    }
	func convert() -> Void
	{
    print("func \(name) -> \(type)")
	print("  {")
	switch(type)
	 {
     case "Int" : print("  return 0")
	 case "Double" : print("  return 0")
	 case "Bool" : print("  return false")
     case "String" : print("  return \"not implemented\"")		 
	 default :	  print("  return ")
	 }
	print("  }")	
	}
	func shortConvert() -> Void
	{
    print("func \(name) -> \(type)")
	}
}
func isProtocol(name:String)-> ProtocolData?
{
	for i in data1
	{
		if i.name == name
		 {return i }
	}
	return nil
}
func isClass(name:String)->Bool
{
	for i in data
	{
		if i.name == name
		 {return true }
	}
	return false
}
class ClassAndExpansion
{
    var name:String = ""
    var inherits:[String] = []
    var funcArr:[Function] = []
    var attributes:[Attribute] = []
	func convert() -> Void
	{}
	      init(name:String="", inherits:[String] = [],attributes:[Attribute] = [],funcArr:[Function] = [])
    {
      self.name = name
      self.inherits = inherits	
      self.funcArr = funcArr
      self.attributes = attributes
    }
	func readProperties(file:String,i:inout Int) -> Void
{
	var ch:Character
	//var ch1:Character
	var tuple:(str:String,ch:Character)
	var tuple1:(str:String,ch:Character)
	var tuple2:(str:String,ch:Character)
	repeat
       {
        ch = file[file.index(file.startIndex, offsetBy: i)] // ch is "-" or ":"  
	    i += 1
		skipWhite(file:file,i:&i)                            
		tuple = skipSymbol(file:file,i:&i,till:[" "])   // get name     
	    skipSymbol(file:file,i:&i,till:[":",">"])            
		skipWhite(file:file,i:&i)                            
		tuple1 = skipSymbol(file:file,i:&i,till:[" "])  // get type
		if i < 0 {break}
	    if ch == "-"
		{
		self.attributes.append(Attribute(name:tuple.str,type:tuple1.str))		
		}
		else
		{
		self.funcArr.append(Function(name:tuple.str,type:tuple1.str))	
		}
		tuple2 = skipSymbol(file:file,i:&i,till:[":","-","$","+"]) ;if i < 0 {break}
		i-=1
		   
        }
    while (i < file.characters.count && i >= 0 && tuple2.ch != "$" && tuple2.ch != "+"  )	
}
	func readData(file:String,i:inout Int,tuple: inout(str:String,ch:Character) ) -> Void
     {
     skipWhite(file:file,i:&i) 
		if i < 0 {return}
	  tuple  = skipSymbol(file:file,i:&i,till:[" "])	
	  self.name = tuple.str
	  tuple = skipSymbol(file:file,i:&i,till:["$","+","-",":"])	
	  i -= 1	
	  if tuple.ch == "-" 	
	  {self.readProperties(file:file,i:&i)}	
	  else if tuple.ch == ":"     // function or inherited class
	  { 
	    var icopy:Int = i + 1
		skipWhite(file:file,i:&icopy)  
		var tuple2 = skipSymbol(file:file,i:&icopy,till:[" ",","])  
		if !isFunction(str:tuple2.str)
		{
			while(true)
			{   
			self.inherits.append(tuple2.str)    
			icopy -= 1
		    tuple2 = skipSymbol(file:file,i:&icopy,till:[",","-",":","$","+"])
			if tuple2.ch != "," || icopy < 0
			{break}							
			skipWhite(file:file,i:&icopy)
			tuple2 = skipSymbol(file:file,i:&icopy,till:[" ",","])					
		    }
	      i = icopy	- 1// - 1
			if tuple2.ch == ":" || tuple2.ch == "-"
		    {self.readProperties(file:file,i:&i)}	
	    }
	   else	
		  {
		  self.readProperties(file:file,i:&i)	  
		  }
	  }
	 }
}
class ClassData:ClassAndExpansion
{   
	  var inheritsClass:Bool = false
      override init(name:String="", inherits:[String] = [],attributes: [Attribute] = [],funcArr:[Function] = [])
    {
	  super.init()	
      self.name = name
      self.inherits = inherits
	  self.funcArr = funcArr
      self.attributes = attributes	
    }
	func addProtocolFunc() -> Void
	{
	for i in inherits
		{
			var prot = isProtocol(name: i)
			if prot != nil
			{
				
				for j in prot!.attributes
				{
				 if  !containsAttribute(attribute:j,arr: self.attributes)
				  {
					  self.attributes.append(j)
				  }
				}
				for j in prot!.funcArr
				{
				 if  !containsFunction(function:j,arr: self.funcArr)
				  {
					  self.funcArr.append(j)
				  }
				}
			}
			else
			{
				inheritsClass = true
			}
		}
	}	
	func addInit()-> Void
	{
	print("init(",terminator: " ")
	if attributes.count == 1
	 {
	 print("\(attributes[0].name) : \(attributes[0].type) = \(attributes[0].defaultValue)",terminator : "  ") 	 
	 }
	else if attributes.count > 1
	{	
	for i in 0 ..< attributes.count - 1
	{
	print("\(attributes[i].name) : \(attributes[i].type) = \(attributes[i].defaultValue)",terminator : " , ")	
	}
	print("\(attributes[attributes.count - 1].name) : \(attributes[attributes.count - 1].type) = \(attributes[attributes.count - 1].defaultValue) ",terminator :" ")
	}	
	print(")")
	print("  {")
	for i in attributes
	{
		print("   self.\(i.name) = \(i.name)")
	}
	if inheritsClass == true
	{print("   super.init()")}	
    print("  }")
	}	
	override func convert() -> Void
	{
	addProtocolFunc()	
    print("class \(name)",terminator: " ")	
	if inherits != []
		{
			print(": ",terminator: "")
			for i in 0..<inherits.count - 1
			{
			 print(inherits[i],terminator: ", ")
			}
			print(inherits[inherits.count - 1])
		}
	else
		{
			print(" ")
		}	
	print(" {")	
     for i in attributes
		{
		 i.convert()	
		}
		for i in funcArr
		{
		 i.convert()	
		}	
	addInit()
    print(" }")
	print(" ")	
    }
}
class ProtocolData : ClassAndExpansion
{   
   override   init(name:String="", inherits:[String] = [],attributes:[Attribute] = [],funcArr:[Function] = [])
    {
	  super.init()	
      self.name = name
      self.inherits = inherits	
      self.funcArr = funcArr
      self.attributes = attributes
    }
	override func convert() -> Void
	{
		 print("protocol \(name)",terminator: " ")
	if inherits != []
		{
			print(": ",terminator: "")
			for i in 0..<inherits.count - 1
			{
			 print(inherits[i],terminator: ", ")
			}
			print(inherits[inherits.count - 1])
		}
	else
		{
			print(" ")
		}
	print(" {")	
     for i in attributes
		{
		 i.protocolConvert() 	
		}
		for i in funcArr
		{
		 i.shortConvert()	
		}	
    print(" }")
	print(" ")	
    }
}

func isFunction(str:String)->Bool
{
	var j:Int = 0
	var ch:Character
	while (j < str.characters.count)
	{
     ch = str[str.index(str.startIndex, offsetBy: j)]
	 if ch == "("
	 {return true}
	j += 1
	}
	return false
}
func contains(_ arr:[Character],_ ch:Character)->Bool
{
    for i:Character in arr
    {
        if i == ch
        {
            return true
        }
    }
    return false
}
func skipSymbol(file:String,i:inout Int,till:[Character])->(str:String,ch:Character)
{
    var str:String = ""
    var ch:Character = " "
    repeat
                   {
                       ch = file[file.index(file.startIndex, offsetBy: i)]
                       str.insert(ch, at: str.endIndex)
                       i += 1
                   }
    while (i < file.characters.count && !contains(till,ch))
    if i == file.characters.count
    {
		i = -50
		//return (str,"1") 
	}
    ch=str.remove(at: str.index(before: str.endIndex))
    return (str,ch) 
}
func skipWhite(file:String,i:inout Int) -> Void
{
	var ch:Character
	repeat
                   {
                       ch = file[file.index(file.startIndex, offsetBy: i)]
                       i += 1
                   }
    while (i < file.characters.count && ch == " ")
	i -= 1
}

var (data,data1):([ClassData],[ProtocolData]) = ([],[])

func parse(file:String)->([(ClassData)],[(ProtocolData)])
{
    var data:[(ClassData)] = []    // classes
	var data1:[ProtocolData] = []  // protocols
    var i = 0
	var tuple:(str:String,ch:Character)
	tuple = skipSymbol(file:file,i:&i,till:["$","+"])
	i -= 1
	while(i >= 0)
	{
	 let ch = file[file.index(file.startIndex, offsetBy: i)]	
	  i += 1
	  if ch == "$"
		{
		var c:ClassData = ClassData()			
		c.readData(file:file,i:&i,tuple: &tuple)
		data.append(c)
		}
      else
		{
		var c:ProtocolData = ProtocolData()		
		c.readData(file:file,i:&i,tuple: &tuple)
		data1.append(c)	
		}
	  if i<0 {break}
	  } 
  return (data,data1)
}
let file:String = 
"$ Day - something : String   : getsomething() -> String $ Time : Day, Printable    - hour : Int  - minutes : Int  - seconds :  Double   : getHour() -> Int  : print() -> Void  $ Appointment : Time     : getDay() -> String   - day : Int   : isImpotrant() -> Bool     + Printable  : print() -> Void  : print2() -> Void - protocolVar : Int   "
 (data,data1) = parse(file:file)
for cl in data1   // print protocols
{
	cl.convert()
}
for cl in data   // print classes
{
	(cl).convert()
}
