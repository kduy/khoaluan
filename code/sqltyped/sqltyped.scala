
//select name, age from person
TypedStatement(
	List(), //input
	List(   //output
		TypedValue(
			name,
			(String,12),
			false,
			None,
			Column
			(name,Table(person,None))
		), 
		TypedValue(
			age,(Int,4),false,None,Column(age,Table(person,None))
		)
	),
	true, //isQuery
	Map(  //uniqueConstrains
		Table(person,None) -> List(List(Column(id,Table(person,None))))
	),
	List( //generateKeyTypes
		TypedValue(
			id,(Long,-5),false,Some(person),Column(id,Table(person,None))
		), 
		TypedValue(
			age,(Int,4),false,None,Column(age,Table(person,None))
		), 
		TypedValue(
			salary,(Int,4),false,None,Column(salary,Table(person,None))
		)
	),
	Many // Number of result
)

Ok(
	TypedStatement(
		List(),
		List(
			TypedValue(salary,(Int,4),false,None,Column(salary,Table(person,None)))),
		true,
		Map(
			Table(person,None) -> List(List(Column(id,Table(person,None))))
		),
		List(
			TypedValue(id,(Long,-5),false,Some(person),Column(id,Table(person,None))), 
			TypedValue(age,(Int,4),false,None,Column(age,Table(person,None))), 
			TypedValue(salary,(Int,4),false,None,Column(salary,Table(person,None)))),Many))


//select age * 5 as hell from person where age = ?

Ok(
	TypedStatement(
		List(
			TypedValue(age,(Int,4),false,None,Column(age,Table(person,None)))
		),
		List(TypedValue(hell,(Int,4),false,None,Column(age,Table(person,None)))),
		true,
		Map(Table(person,None) -> List(List(Column(id,Table(person,None))))),
		List(TypedValue(id,(Long,-5),false,Some(person),Column(id,Table(person,None))), 
			TypedValue(age,(Int,4),false,None,Column(age,Table(person,None))), 
			TypedValue(salary,(Int,4),false,None,Column(salary,Table(person,None)))),Many))

case class TypedStatement(
    input: List[TypedValue]
  , output: List[TypedValue]
  , isQuery: Boolean
  , uniqueConstraints: Map[Table, List[List[Column[Table]]]]
  , generatedKeyTypes: List[TypedValue]
  , numOfResults: NumOfResults.NumOfResults = NumOfResults.Many)


case class TypedValue(name: String, tpe: (Type, Int), nullable: Boolean, tag: Option[String], term: Term[Table])
