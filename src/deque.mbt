///|
#as_free_fn(cons)
pub fn[A] T::cons(self : T[A], x : A) -> T[A] {
  let (lst, tsl) = self.0
  (lst.cons(x), tsl)
}

///|
#as_free_fn(append)
pub fn[A] T::append(self : T[A], other : T[A]) -> T[A] {
  let (lst1, tsl1) = self.0
  let (lst2, tsl2) = other.0
  let lst = lst1
  let tsl = lst2.foldl(Tsil::snoc, tsl1).append(tsl2)
  (lst, tsl)
}

///|
#as_free_fn(snoc)
pub fn[A] T::snoc(self : T[A], x : A) -> T[A] {
  let (lst, tsl) = self.0
  (lst, tsl.snoc(x))
}

///|
#as_free_fn(reverse)
pub fn[A] T::reverse(self : T[A]) -> T[A] {
  let (lst, tsl) = self.0
  (tsl.reverse(), lst.reverse())
}

///|
#as_free_fn(uncons)
pub fn[A] T::uncons(self : T[A]) -> (A, T[A])? {
  let (lst, tsl) = self.0
  match lst.0 {
    More(head, tail~) => Some((head, (List(tail), tsl)))
    Empty =>
      match tsl.0.rev() {
        More(head, tail~) => Some((head, (List(tail), Tsil::empty())))
        Empty => None
      }
  }
}

///|
#as_free_fn(unsnoc)
pub fn[A] T::unsnoc(self : T[A]) -> (A, T[A])? {
  let (lst, tsl) = self.0
  match tsl.0 {
    More(last, tail=init) => Some((last, (lst, Tsil(init))))
    Empty =>
      match lst.0.rev() {
        More(last, tail=init) => Some((last, (List::empty(), Tsil(init))))
        Empty => None
      }
  }
}

///|
#as_free_fn(map)
pub fn[A, B] T::map(self : T[A], f : (A) -> B) -> T[B] {
  let (lst, tsl) = self.0
  (lst.0.map(f), tsl.0.map(f))
}

///|
#as_free_fn(foldl)
pub fn[A, B] T::foldl(self : T[A], z : B, f : (B, A) -> B) -> B {
  let (cons, snoc) = self.0
  let z = cons.foldl(f, z)
  snoc.foldl(z, f)
}

///|
#as_free_fn(foldr)
pub fn[A, B] T::foldr(self : T[A], z : B, f : (B, A) -> B) -> B {
  let (cons, snoc) = self.0
  let z = snoc.foldr(z, f)
  cons.foldr(z, f)
}

///|
#as_free_fn(bind)
pub fn[A, B] T::bind(self : T[A], k : (A) -> T[B]) -> T[B] {
  fn step(acc : List[B], a : A) -> List[B] {
    let (lst, tsl) = k(a).0
    lst.append(tsl.reverse().append(acc))
  }

  let (lst, tsl) = self.0
  let z = tsl.reverse().foldl(step, List::empty())
  let lst = lst.foldr(z, step)
  (lst, Tsil::empty())
}

///|
#as_free_fn(join)
pub fn[A] T::join(self : T[T[A]]) -> T[A] {
  self.bind(fn(x) { x })
}

///|
#as_free_fn(iter)
pub fn[A] T::iter(self : T[A]) -> Iter[A] {
  Iter::new(fn(k) {
    let (lst, tsl) = self.0
    match lst.iter().run(k) {
      IterContinue => tsl.iter().run(k)
      IterEnd => IterEnd
    }
  })
}

///|
#as_free_fn(rev_iter)
pub fn[A] T::rev_iter(self : T[A]) -> Iter[A] {
  Iter::new(fn(k) {
    let (lst, tsl) = self.0
    match tsl.rev_iter().run(k) {
      IterContinue => lst.rev_iter().run(k)
      IterEnd => IterEnd
    }
  })
}

///|
#as_free_fn(to_array)
pub fn[A] T::to_array(self : T[A]) -> Array[A] {
  self.iter().to_array()
}

///|
pub impl[A : Show] Show for T[A] with output(xs, logger) {
  logger.write_iter(xs.iter(), prefix="@deque.of([", suffix="])")
}

///|
#as_free_fn(filter)
pub fn[A] T::filter(self : T[A], f : (A) -> Bool) -> T[A] {
  let (lst, tsl) = self.0
  (lst.0.filter(f), tsl.0.filter(f))
}

///|
#as_free_fn(filter_map)
pub fn[A, B] T::filter_map(self : T[A], f : (A) -> B?) -> T[B] {
  let (lst, tsl) = self.0
  (lst.0.filter_map(f), tsl.0.filter_map(f))
}

///|
#as_free_fn(head)
pub fn[A] T::head(self : T[A]) -> A? {
  self.uncons().map(x => x.0)
}

///|
#as_free_fn(last)
pub fn[A] T::last(self : T[A]) -> A? {
  self.unsnoc().map(x => x.0)
}

///|
#as_free_fn(tail)
pub fn[A] T::tail(self : T[A]) -> T[A] {
  match self.uncons() {
    None => empty()
    Some((_, xs)) => xs
  }
}

///|
#as_free_fn(init_)
pub fn[A] T::init_(self : T[A]) -> T[A] {
  match self.unsnoc() {
    None => empty()
    Some((_, xs)) => xs
  }
}

///|
#as_free_fn(take)
pub fn[A] T::take(self : T[A], n : Int) -> T[A] {
  self.iter().take(n) |> from_iter
}

///|
#as_free_fn(drop)
pub fn[A] T::drop(self : T[A], n : Int) -> T[A] {
  self.iter().drop(n) |> from_iter
}

///|
#as_free_fn(takeWhile)
pub fn[A] T::takeWhile(self : T[A], f : (A) -> Bool) -> T[A] {
  self.iter().take_while(f) |> from_iter
}

///|
#as_free_fn(dropWhile)
pub fn[A] T::dropWhile(self : T[A], f : (A) -> Bool) -> T[A] {
  self.iter().drop_while(f) |> from_iter
}

///|
#as_free_fn(empty)
pub fn[A] T::empty() -> T[A] {
  (List::empty(), Tsil::empty())
}

///|
#as_free_fn(from_list)
pub fn[A] T::from_list(xs : @list.List[A]) -> T[A] {
  (List(xs), Tsil::empty())
}

///|
#as_free_fn(from_rev_list)
pub fn[A] T::from_rev_list(xs : @list.List[A]) -> T[A] {
  (List::empty(), Tsil(xs))
}

///|
#as_free_fn(of)
pub fn[A] T::of(xs : FixedArray[A]) -> T[A] {
  @list.from_array(xs) |> from_list
}

///|
#as_free_fn(from_iter)
pub fn[A] T::from_iter(xs : Iter[A]) -> T[A] {
  (List::empty(), @list.from_iter_rev(xs))
}

///|
#as_free_fn(singleton)
pub fn[A] T::singleton(x : A) -> T[A] {
  (@list.cons(x, @list.empty()), @list.empty())
}
