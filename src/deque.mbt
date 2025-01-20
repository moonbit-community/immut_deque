///|
pub fn cons[A](self : T[A], x : A) -> T[A] {
  let (lst, tsl) = self._
  (lst.cons(x), tsl)
}

///|
pub fn append[A](self : T[A], other : T[A]) -> T[A] {
  let (lst1, tsl1) = self._
  let (lst2, tsl2) = other._
  let lst = lst1
  let tsl = tsl1.append(lst2.reverse()).append(tsl2)
  (lst, tsl)
}

///|
pub fn snoc[A](self : T[A], x : A) -> T[A] {
  let (lst, tsl) = self._
  (lst, tsl.snoc(x))
}

///|
pub fn reverse[A](self : T[A]) -> T[A] {
  let (lst, tsl) = self._
  (tsl.reverse(), lst.reverse())
}

///|
pub fn uncons[A](self : T[A]) -> (A, T[A])? {
  let (lst, tsl) = self._
  match lst._ {
    Cons(head, tail) => Some((head, (List(tail), tsl)))
    Nil =>
      match tsl._.rev() {
        Cons(head, tail) => Some((head, (List(tail), Tsil(Nil))))
        Nil => None
      }
  }
}

///|
pub fn unsnoc[A](self : T[A]) -> (A, T[A])? {
  let (lst, tsl) = self._
  match tsl._ {
    Cons(last, init) => Some((last, (List(init), tsl)))
    Nil =>
      match lst._.rev() {
        Cons(last, init) => Some((last, (List(Nil), Tsil(init))))
        Nil => None
      }
  }
}

///|
pub fn map[A, B](self : T[A], f : (A) -> B) -> T[B] {
  let (lst, tsl) = self._
  (lst._.map(f), tsl._.map(f))
}

///|
pub fn foldl[A, B](self : T[A], f : (B, A) -> B, init~ : B) -> B {
  let (cons, snoc) = self._
  let init = cons.foldl(f, init~)
  snoc.foldl(f, init~)
}

///|
pub fn foldr[A, B](self : T[A], f : (A, B) -> B, init~ : B) -> B {
  let (cons, snoc) = self._
  let init = snoc.foldr(f, init~)
  cons.foldr(f, init~)
}

///|
pub fn bind[A, B](self : T[A], k : (A) -> T[B]) -> T[B] {
  fn step(a : A, acc : List[B]) -> List[B] {
    let (lst, tsl) = k(a)._
    lst.append(tsl.reverse().append(acc))
  }

  let (lst, tsl) = self._
  let init = tsl.reverse().foldr(step, init=List(Nil))
  let lst = lst.foldr(step, init~)
  (lst, Tsil(Nil))
}

///|
pub fn join[A](self : T[T[A]]) -> T[A] {
  self.bind(fn(x) { x })
}

///|
pub fn from_list[A](xs : @immut/list.T[A]) -> T[A] {
  (List(xs), Tsil(Nil))
}

///|
pub fn from_rev_list[A](xs : @immut/list.T[A]) -> T[A] {
  (List(Nil), Tsil(xs))
}

///|
pub fn iter[A](self : T[A]) -> Iter[A] {
  Iter::new(fn(k) {
    let (lst, tsl) = self._
    match lst.iter().run(k) {
      IterContinue => tsl.iter().run(k)
      IterEnd => IterEnd
    }
  })
}

///|
pub impl[A : Show] Show for T[A] with output(xs, logger) {
  logger.write_iter(xs.iter(), prefix="@deque.of([", suffix="])")
}

///|
pub fn of[A](xs : FixedArray[A]) -> T[A] {
  xs |> @immut/list.of |> from_list
}
