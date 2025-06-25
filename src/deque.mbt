///|
pub fn[A] T::cons(self : T[A], x : A) -> T[A] {
  let (lst, tsl) = self.inner()
  (lst.cons(x), tsl)
}

///|
pub fn[A] T::append(self : T[A], other : T[A]) -> T[A] {
  let (lst1, tsl1) = self.inner()
  let (lst2, tsl2) = other.inner()
  let lst = lst1
  let tsl = lst2.foldl(Tsil::snoc, tsl1).append(tsl2)
  (lst, tsl)
}

///|
pub fn[A] T::snoc(self : T[A], x : A) -> T[A] {
  let (lst, tsl) = self.inner()
  (lst, tsl.snoc(x))
}

///|
pub fn[A] T::reverse(self : T[A]) -> T[A] {
  let (lst, tsl) = self.inner()
  (tsl.reverse(), lst.reverse())
}

///|
pub fn[A] T::uncons(self : T[A]) -> (A, T[A])? {
  let (lst, tsl) = self.inner()
  match lst.inner() {
    More(head, tail~) => Some((head, (List(tail), tsl)))
    Empty =>
      match tsl.inner().rev() {
        More(head, tail~) => Some((head, (List(tail), Tsil::empty())))
        Empty => None
      }
  }
}

///|
pub fn[A] T::unsnoc(self : T[A]) -> (A, T[A])? {
  let (lst, tsl) = self.inner()
  match tsl.inner() {
    More(last, tail=init) => Some((last, (lst, Tsil(init))))
    Empty =>
      match lst.inner().rev() {
        More(last, tail=init) => Some((last, (List::empty(), Tsil(init))))
        Empty => None
      }
  }
}

///|
pub fn[A, B] T::map(self : T[A], f : (A) -> B) -> T[B] {
  let (lst, tsl) = self.inner()
  (lst.inner().map(f), tsl.inner().map(f))
}

///|
pub fn[A, B] T::foldl(self : T[A], z : B, f : (B, A) -> B) -> B {
  let (cons, snoc) = self.inner()
  let z = cons.foldl(f, z)
  snoc.foldl(z, f)
}

///|
pub fn[A, B] T::foldr(self : T[A], z : B, f : (B, A) -> B) -> B {
  let (cons, snoc) = self.inner()
  let z = snoc.foldr(z, f)
  cons.foldr(z, f)
}

///|
pub fn[A, B] T::bind(self : T[A], k : (A) -> T[B]) -> T[B] {
  fn step(acc : List[B], a : A) -> List[B] {
    let (lst, tsl) = k(a).inner()
    lst.append(tsl.reverse().append(acc))
  }

  let (lst, tsl) = self.inner()
  let z = tsl.reverse().foldl(step, List::empty())
  let lst = lst.foldr(z, step)
  (lst, Tsil::empty())
}

///|
pub fn[A] T::join(self : T[T[A]]) -> T[A] {
  self.bind(fn(x) { x })
}

///|
pub fn[A] T::iter(self : T[A]) -> Iter[A] {
  Iter::new(fn(k) {
    let (lst, tsl) = self.inner()
    match lst.iter().run(k) {
      IterContinue => tsl.iter().run(k)
      IterEnd => IterEnd
    }
  })
}

///|
pub fn[A] T::rev_iter(self : T[A]) -> Iter[A] {
  Iter::new(fn(k) {
    let (lst, tsl) = self.inner()
    match tsl.rev_iter().run(k) {
      IterContinue => lst.rev_iter().run(k)
      IterEnd => IterEnd
    }
  })
}

///|
pub fn[A] T::to_array(self : T[A]) -> Array[A] {
  self.iter().to_array()
}

///|
pub impl[A : Show] Show for T[A] with output(xs, logger) {
  logger.write_iter(xs.iter(), prefix="@deque.of([", suffix="])")
}

///|
pub fn[A] T::filter(self : T[A], f : (A) -> Bool) -> T[A] {
  let (lst, tsl) = self.inner()
  (lst.inner().filter(f), tsl.inner().filter(f))
}

///|
pub fn[A, B] T::filter_map(self : T[A], f : (A) -> B?) -> T[B] {
  let (lst, tsl) = self.inner()
  (lst.inner().filter_map(f), tsl.inner().filter_map(f))
}

///|
pub fn[A] T::head(self : T[A]) -> A? {
  self.uncons().map(x => x.0)
}

///|
pub fn[A] T::last(self : T[A]) -> A? {
  self.unsnoc().map(x => x.0)
}

///|
pub fn[A] T::tail(self : T[A]) -> T[A] {
  match self.uncons() {
    None => empty()
    Some((_, xs)) => xs
  }
}

///|
pub fn[A] T::init_(self : T[A]) -> T[A] {
  match self.unsnoc() {
    None => empty()
    Some((_, xs)) => xs
  }
}

///|
pub fn[A] T::take(self : T[A], n : Int) -> T[A] {
  self.iter().take(n) |> from_iter
}

///|
pub fn[A] T::drop(self : T[A], n : Int) -> T[A] {
  self.iter().drop(n) |> from_iter
}

///|
pub fn[A] T::takeWhile(self : T[A], f : (A) -> Bool) -> T[A] {
  self.iter().take_while(f) |> from_iter
}

///|
pub fn[A] T::dropWhile(self : T[A], f : (A) -> Bool) -> T[A] {
  self.iter().drop_while(f) |> from_iter
}

///|
pub fn[A] T::empty() -> T[A] {
  (List::empty(), Tsil::empty())
}

///|
pub fn[A] T::from_list(xs : @list.T[A]) -> T[A] {
  (List(xs), Tsil::empty())
}

///|
pub fn[A] T::from_rev_list(xs : @list.T[A]) -> T[A] {
  (List::empty(), Tsil(xs))
}

///|
pub fn[A] T::of(xs : FixedArray[A]) -> T[A] {
  @list.of(xs) |> from_list
}

///|
pub fn[A] T::from_iter(xs : Iter[A]) -> T[A] {
  (List::empty(), @list.from_iter_rev(xs))
}

///|
pub fn[A] T::singleton(x : A) -> T[A] {
  (@list.construct(x, @list.empty()), @list.empty())
}

///|
pub fnalias T::(
  append,
  bind,
  cons,
  drop,
  dropWhile,
  empty,
  filter,
  filter_map,
  foldl,
  foldr,
  from_iter,
  from_list,
  from_rev_list,
  head,
  init_,
  iter,
  join,
  last,
  map,
  of,
  rev_iter,
  reverse,
  singleton,
  snoc,
  tail,
  take,
  takeWhile,
  to_array,
  uncons,
  unsnoc
)
