
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
        // clall unroll.foreach (f(i)) // f ~ println
```