///|
fn[A] List::cons(self : List[A], x : A) -> List[A] {
  @list.cons(x, self.0)
}

///|
fn[A] List::reverse(self : List[A]) -> Tsil[A] {
  Tsil(self.0)
}

///|
fn[A, B] List::foldl(self : List[A], f : (B, A) -> B, z : B) -> B {
  self.0.fold(f, init=z)
}

///|
fn[A, B] List::foldr(self : List[A], z : B, f : (B, A) -> B) -> B {
  self.0.rev().fold(init=z, f)
}

///|
fn[A] List::iter(self : List[A]) -> Iter[A] {
  self.0.iter()
}

///|
fn[A] List::rev_iter(self : List[A]) -> Iter[A] {
  self.0.rev().iter()
}

///|
fn[A] List::append(self : List[A], other : List[A]) -> List[A] {
  self.0 + other.0
}

///|
test "append" {
  let xs = [1, 2, 3] |> List::of
  let ys = [4, 5, 6] |> List::of
  inspect(xs, content="@list.from_array([1, 2, 3])")
  inspect(ys, content="@list.from_array([4, 5, 6])")
  inspect(xs.append(ys), content="@list.from_array([1, 2, 3, 4, 5, 6])")
}

///|
fn[A] List::of(xs : FixedArray[A]) -> List[A] {
  xs |> @list.from_array
}

///|
fn[A] List::empty() -> List[A] {
  @list.empty()
}

///|
impl[A : Show] Show for List[A] with output(self, logger) {
  self.0.output(logger)
}
