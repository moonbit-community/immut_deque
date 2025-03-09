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
  let tsl = lst2.foldl(Tsil::snoc, tsl1).append(tsl2)
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
    Cons(last, init) => Some((last, (lst, Tsil(init))))
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
pub fn foldl[A, B](self : T[A], f : (B, A) -> B, z : B) -> B {
  let (cons, snoc) = self._
  let z = cons.foldl(f, z)
  snoc.foldl(f, z)
}

///|
pub fn foldr[A, B](self : T[A], f : (B, A) -> B, z : B) -> B {
  let (cons, snoc) = self._
  let z = snoc.foldr(f, z)
  cons.foldr(f, z)
}

///|
pub fn bind[A, B](self : T[A], k : (A) -> T[B]) -> T[B] {
  fn step(acc : List[B], a : A) -> List[B] {
    let (lst, tsl) = k(a)._
    lst.append(tsl.reverse().append(acc))
  }

  let (lst, tsl) = self._
  let z = tsl.reverse().foldl(step, List(Nil))
  let lst = lst.foldr(step, z)
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
pub fn rev_iter[A](self : T[A]) -> Iter[A] {
  Iter::new(fn(k) {
    let (lst, tsl) = self._
    match tsl.rev_iter().run(k) {
      IterContinue => lst.rev_iter().run(k)
      IterEnd => IterEnd
    }
  })
}

///|
pub fn to_array[A](self : T[A]) -> Array[A] {
  self.iter().to_array()
}

///|
pub impl[A : Show] Show for T[A] with output(xs, logger) {
  logger.write_iter(xs.iter(), prefix="@deque.of([", suffix="])")
}

///|
pub fn of[A](xs : FixedArray[A]) -> T[A] {
  xs |> @immut/list.of |> from_list
}

///|
pub fn from_iter[A](xs : Iter[A]) -> T[A] {
  let mut tsl = Tsil::empty()
  xs.just_run(fn(x) {
    tsl = tsl.snoc(x)
    IterContinue
  })
  (List::empty(), tsl)
}

///|
pub fn empty[A]() -> T[A] {
  (List(Nil), Tsil(Nil))
}

///|
pub fn filter[A](self : T[A], f : (A) -> Bool) -> T[A] {
  let (lst, tsl) = self._
  (lst._.filter(f), tsl._.filter(f))
}

///|
pub fn filter_map[A, B](self : T[A], f : (A) -> B?) -> T[B] {
  let (lst, tsl) = self._
  (lst._.filter_map(f), tsl._.filter_map(f))
}

///|
pub fn head[A](self : T[A]) -> A? {
  self.uncons().map(@tuple.fst)
}

///|
pub fn last[A](self : T[A]) -> A? {
  self.unsnoc().map(@tuple.fst)
}

///|
pub fn tail[A](self : T[A]) -> T[A] {
  match self.uncons() {
    None => empty()
    Some((_, xs)) => xs
  }
}

///|
pub fn init_[A](self : T[A]) -> T[A] {
  match self.unsnoc() {
    None => empty()
    Some((_, xs)) => xs
  }
}

///|
pub fn take[A](self : T[A], n : Int) -> T[A] {
  self.iter().take(n) |> from_iter
}

///|
pub fn drop[A](self : T[A], n : Int) -> T[A] {
  self.iter().drop(n) |> from_iter
}

///|
pub fn takeWhile[A](self : T[A], f : (A) -> Bool) -> T[A] {
  self.iter().take_while(f) |> from_iter
}

///|
pub fn dropWhile[A](self : T[A], f : (A) -> Bool) -> T[A] {
  self.iter().drop_while(f) |> from_iter
}
