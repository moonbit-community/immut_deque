///|
fn Tsil::snoc[A](self : Tsil[A], x : A) -> Tsil[A] {
  @list.construct(x, self._)
}

///|
fn Tsil::reverse[A](self : Tsil[A]) -> List[A] {
  self._
}

///|
fn flip[B, A, C](f : (B, A) -> C) -> (A, B) -> C {
  fn(a, b) { f(b, a) }
}

///|
fn Tsil::foldl[A, B](self : Tsil[A], z : B, f : (B, A) -> B) -> B {
  self._.rev().fold(f, init=z)
}

///|
fn Tsil::foldr[A, B](self : Tsil[A], z : B, f : (B, A) -> B) -> B {
  self._.fold(f, init=z)
}

///|
fn Tsil::iter[A](self : Tsil[A]) -> Iter[A] {
  self._.rev().iter()
}

///|
fn Tsil::rev_iter[A](self : Tsil[A]) -> Iter[A] {
  self._.iter()
}

///|
fn Tsil::append[A](self : Tsil[A], other : Tsil[A]) -> Tsil[A] {
  @list.concat(other._, self._)
}

///|
test "append" {
  let xs = [1, 2, 3] |> Tsil::of
  let ys = [4, 5, 6] |> Tsil::of
  inspect!(xs, content="@tsil.of([1, 2, 3])")
  inspect!(ys, content="@tsil.of([4, 5, 6])")
  inspect!(xs.append(ys), content="@tsil.of([1, 2, 3, 4, 5, 6])")
}

///|
fn Tsil::of[A](xs : FixedArray[A]) -> Tsil[A] {
  xs.fold(init=Tsil::empty(), Tsil::snoc)
}

///|
test "Tsil::of/empty" {
  let empty : FixedArray[Int] = []
  inspect!(Tsil::of(empty), content="@tsil.of([])")
}

///|
test "Tsil::of/single" {
  inspect!(Tsil::of([1]), content="@tsil.of([1])")
}

///|
test "Tsil::of/multiple" {
  inspect!(Tsil::of([1, 2, 3, 4, 5]), content="@tsil.of([1, 2, 3, 4, 5])")
}

///|
impl[A : Show] Show for Tsil[A] with output(self, logger) {
  logger.write_iter(self.iter(), prefix="@tsil.of([", suffix="])")
}

///|
fn Tsil::empty[A]() -> Tsil[A] {
  @list.empty()
}
