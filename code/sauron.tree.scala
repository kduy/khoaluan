performing macro expansion 
com.github.pathikrit.sauron.`package`.lens[Person, String](p1)(((x$1: Person) => x$1.address.street.name))

 at source-/Volumes/Data/WORKSPACE/git/thesis/sauron/src/test/scala/com/github/pathikrit/sauron/suites/TestSauron.scala,line-17,offset=542


((fresh$macro$1) => p1.copy(
	address = p1.address.copy(street = p1.address.street.copy(
		name = fresh$macro$1(p1.address.street.name)))
	))

Function(
	List(
		ValDef(Modifiers(PARAM), TermName("fresh$macro$1"), TypeTree(), EmptyTree)
	), 
	Apply(
		Select(Ident(TermName("p1")), TermName("copy")), 
		List(
			AssignOrNamedArg(
				Ident(TermName("address")), 
				Apply(
					Select(
						Select(Ident(TermName("p1")), TermName("address")), 
						TermName("copy")
					), 
					List(
						AssignOrNamedArg(Ident(TermName("street")), Apply(Select(Select(Select(Ident(TermName("p1")), TermName("address")), TermName("street")), TermName("copy")), List(AssignOrNamedArg(Ident(TermName("name")), Apply(Ident(TermName("fresh$macro$1")), List(Select(Select(Select(Ident(TermName("p1")), TermName("address")), TermName("street")), TermName("name"))))))))))))))


// function call tree
Apply(
	Select(Ident (...), TermName (...))
	List(
		Literal(Constant("1"))
		,...
	)
)