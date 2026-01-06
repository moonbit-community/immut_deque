///|
fn[A] Tsil::snoc(self : Tsil[A], x : A) -> Tsil[A] {
  @list.cons(x, self.0)
}

///|
fn[A] Tsil::reverse(self : Tsil[A]) -> List[A] {
  List(self.0)
}

///|
fn[B, A, C] flip(f : (B, A) -> C) -> (A, B) -> C {
  fn(a, b) { f(b, a) }
}

///|
fn[A, B] Tsil::foldl(self : Tsil[A], z : B, f : (B, A) -> B) -> B {
  self.0.rev().fold(f, init=z)
}

///|
fn[A, B] Tsil::foldr(self : Tsil[A], z : B, f : (B, A) -> B) -> B {
  self.0.fold(f, init=z)
}

///|
fn[A] Tsil::iter(self : Tsil[A]) -> Iterator[A] {
  self.0.rev().iterator()
}

///|
fn[A] Tsil::rev_iter(self : Tsil[A]) -> Iterator[A] {
  self.0.iterator()
}

///|
fn[A] Tsil::append(self : Tsil[A], other : Tsil[A]) -> Tsil[A] {
  Tsil(other.0 + self.0)
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
  logger.write_iter(self.iter().iter(), prefix="@tsil.of([", suffix="])")
}

///|
fn[A] Tsil::empty() -> Tsil[A] {
  Tsil(@list.empty())
}
