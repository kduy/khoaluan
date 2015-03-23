package com.github.kduy

import scala.reflect.macros.blackbox

package object sauron{

// def type
type Setter[A] => A
type Updater[A, B] = Setter [B] => A
type Lens[A, B] = A => Updater[A, B]
type ~~> [A, B] = Lens[A, B]

// def macro len
def lens[A, B] (obj: A) (path : A=>B) : Updater[A->B] = macro lensImpl[A,B]

// impl macro len
def lensImpl[A, B] (c: blackbox.Context) (obj: c.Expr[A])(path: c.Expr(A=>B)): c.Tree  = {
	import c.universer._

	// split a.b.c
	def split (accessor : c.Tree): List[TermName] = accessor match {
		case q"$pq.$r" => split (pq) :+ r
		case _: Ident => Nil
		case _ => c.abort(c.enclosingPosition, s"Unsupport path element : $accessor")
	}

	// nest 
	def nest (prefix: c.Tree, f: TernName, suffix: List[Termname]): c.Tree = suffix match{
		case p::ps => q"$prefix.copy($p = ${nest(q"$prefix.$p", f, ps)})"
		case Nil => q"$f($prefix)"
	}

	// 
	path.tree match {
		case q"($_) => $accessor" =>
			// f and tree
			val f = TernName(c.freshName())
			val fParamTree = q"val $f = ${q""}"
			// generate tree
			q"{$fParamTree => ${nest(obj.tree, f , split(accessor))}}"
		case _ => c.abort(c.enclosingPosition, s"Path must have shape: _a.b.c.(...); got: ${path.tree}")
	}

}

implicit class LensOps[A, B] (var f: A~~> B) extends AnyVal {
	def andThenLens[C] (g: B~~>C): A~~>C = x => y => f(x)(g(_)(y))
	def composeLens[C] (g: C~~> A ) : C ~~>B = G andThenLens f
}


}