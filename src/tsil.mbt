///|
fn[A] Tsil::snoc(self : Tsil[A], x : A) -> Tsil[A] {
  @list.construct(x, self.inner())
}

///|
fn[A] Tsil::reverse(self : Tsil[A]) -> List[A] {
  self.inner()
}

///|
fn[B, A, C] flip(f : (B, A) -> C) -> (A, B) -> C {
  fn(a, b) { f(b, a) }
}

///|
fn[A, B] Tsil::foldl(self : Tsil[A], z : B, f : (B, A) -> B) -> B {
  self.inner().rev().fold(f, init=z)
}

///|
fn[A, B] Tsil::foldr(self : Tsil[A], z : B, f : (B, A) -> B) -> B {
  self.inner().fold(f, init=z)
}

///|
fn[A] Tsil::iter(self : Tsil[A]) -> Iter[A] {
  self.inner().rev().iter()
}

///|
fn[A] Tsil::rev_iter(self : Tsil[A]) -> Iter[A] {
  self.inner().iter()
}

///|
fn[A] Tsil::append(self : Tsil[A], other : Tsil[A]) -> Tsil[A] {
  @list.T::concat(other.inner(), self.inner())
}

///|
test "append" {
  let xs = [1, 2, 3] |> Tsil::of
  let ys = [4, 5, 6] |> Tsil::of
  inspect(xs, content="@tsil.of([1, 2, 3])")
  inspect(ys, content="@tsil.of([4, 5, 6])")
  inspect(xs.append(ys), content="@tsil.of([1, 2, 3, 4, 5, 6])")
}

///|
fn[A] Tsil::of(xs : FixedArray[A]) -> Tsil[A] {
  xs.fold(init=Tsil::empty(), Tsil::snoc)
}

///|
test "Tsil::of/empty" {
  let empty : FixedArray[Int] = []
  inspect(Tsil::of(empty), content="@tsil.of([])")
}

///|
test "Tsil::of/single" {
  inspect(Tsil::of([1]), content="@tsil.of([1])")
}

///|
test "Tsil::of/multiple" {
  inspect(Tsil::of([1, 2, 3, 4, 5]), content="@tsil.of([1, 2, 3, 4, 5])")
}

///|
impl[A : Show] Show for Tsil[A] with output(self, logger) {
  logger.write_iter(self.iter(), prefix="@tsil.of([", suffix="])")
}

///|
fn[A] Tsil::empty() -> Tsil[A] {
  @list.empty()
}
