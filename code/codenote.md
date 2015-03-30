
###Overload Foreach function
```scala
        def unrollIf(c:Boolean,r: Range) = new {
          def foreach(f: Rep[Int] => Rep[Unit]) = {
            if (c) for (j <- (r.start until r.end):Range)      f(j)
            else   for (j <- (r.start until r.end):Rep[Range]) f(j)
          }
        }

        for (j <- unrollIf(sparse, 0 until n)) {
              v1(i) = v1(i) + a(i).apply(j) * v(j)
            }

```

```scala
        reify {
            def unroll = new {
                def foreach(f: Int => Unit) = {
                    for (j <- (1 to 4)) f(j)
                }
            }; 
            for (i<- unroll) println(i)
        }
        // call unroll.foreach (f(i)) // f ~ println
```

### for - yeild 
1) This
```scala
for(x <- c1; y <- c2; z <-c3) {...}
```
is translated into
```scala
c1.foreach(x => c2.foreach(y => c3.foreach(z => {...})))
```

2) This
```scala
for(x <- c1; y <- c2; z <- c3) yield {...}
```
is translated into
```scala
c1.flatMap(x => c2.flatMap(y => c3.map(z => {...})))
```

3) This
```scala
for(x <- c; if cond) yield {...}
```
is translated on Scala 2.7 into
```scala
c.filter(x => cond).map(x => {...})
```
or, on Scala 2.8, into
```scala
c.withFilter(x => cond).map(x => {...})
```
with a fallback into the former if method withFilter is not available but filter is. Please see the edit below for more information on this.

4) This
```scala
for(x <- c; y = ...) yield {...}
```
is translated into
```scala
c.map(x => (x, ...)).map((x,y) => {...})
```

When you look at very simple for comprehensions, the map/foreach alternatives look, indeed, better. Once you start composing them, though, you can easily get lost in parenthesis and nesting levels. When that happens, for comprehensions are usually much clearer.


I'll show one simple example, and intentionally ommit any explanation. You can decide which syntax was easier to understand.
```scala
l.flatMap(sl => sl.filter(el => el > 0).map(el => el.toString.length))
```
or

```scala
for{
  sl <- l
  el <- sl
  if el > 0
} yield el.toString.length
```