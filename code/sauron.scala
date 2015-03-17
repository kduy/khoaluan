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

}




implicit class LensOps[A, B] (var f: A~~> B) extends AnyVal {
	def andThenLens[C] (g: B~~>C): A~~>C = x => y => f(x)(g(_)(y))
	def composeLens[C] (g: C~~> A ) : C ~~>B = G andThenLens f
}


}