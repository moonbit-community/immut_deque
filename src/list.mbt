///|
fn[A] List::cons(self : List[A], x : A) -> List[A] {
  @list.construct(x, self.inner())
}

///|
fn[A] List::reverse(self : List[A]) -> Tsil[A] {
  self.inner()
}

///|
fn[A, B] List::foldl(self : List[A], f : (B, A) -> B, z : B) -> B {
  self.inner().fold(f, init=z)
}

///|
fn[A, B] List::foldr(self : List[A], z : B, f : (B, A) -> B) -> B {
  self.inner().rev().fold(init=z, f)
}

///|
fn[A] List::iter(self : List[A]) -> Iter[A] {
  self.inner().iter()
}

///|
fn[A] List::rev_iter(self : List[A]) -> Iter[A] {
  self.inner().rev().iter()
}

///|
fn[A] List::append(self : List[A], other : List[A]) -> List[A] {
  @list.T::concat(self.inner(), other.inner())
}

///|
test "append" {
  let xs = [1, 2, 3] |> List::of
  let ys = [4, 5, 6] |> List::of
  inspect(xs, content="@list.of([1, 2, 3])")
  inspect(ys, content="@list.of([4, 5, 6])")
  inspect(xs.append(ys), content="@list.of([1, 2, 3, 4, 5, 6])")
}

///|
fn[A] List::of(xs : FixedArray[A]) -> List[A] {
  xs |> @list.of
}

///|
fn[A] List::empty() -> List[A] {
  @list.empty()
}

///|
impl[A : Show] Show for List[A] with output(self, logger) {
  self.inner().output(logger)
}
