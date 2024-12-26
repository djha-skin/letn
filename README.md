# letn

Iterate naturally.

This is a library which allows the programmer to iterate in a functional way.

It exports one symbol, `letn`, which allows the developer to create a named
let. Named lets allow the developer to create loops and iterations naturally
using tail-call-recursion syntax.

Like this:

```lisp
(letn me ((count 3)
          (result 0))
   (if (= count 0)
     result
     (me (1- count) (1+ result))))
```

This will work efficiently **even if the implementation doesn't support tail
call optimization**.

It also creates a block named after itself, so I could e.g. call `(return-from
me)` anywhere in the above block.

## Caveats

* I just got this working
* Pretty sure it _only_ supports tail call recursion, not any other kind of
  recursion, so none of this:

```lisp
(letn me ((count 3))
  (if (= count 0)
    0
    (+ 1 (me))))
```