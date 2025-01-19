///|
fn List::cons[A](self : List[A], x : A) -> List[A] {
  self._.add(x)
}

///|
fn List::reverse[A](self : List[A]) -> Tsil[A] {
  self._
}

///|
fn List::foldl[A, B](self : List[A], f : (B, A) -> B, init~ : B) -> B {
  self._.fold(f, init~)
}

///|
fn List::foldr[A, B](self : List[A], f : (A, B) -> B, init~ : B) -> B {
  self._.rev_fold(f, init~)
}

///|
fn List::iter[A](self : List[A]) -> Iter[A] {
  self._.iter()
}

///|
fn List::append[A](self : List[A], other : List[A]) -> List[A] {
  self.foldr(flip(List::cons), init=other)
}

test "append" {
  let xs = [1, 2, 3] |> List::of
  let ys = [4, 5, 6] |> List::of
  inspect!(xs, content="@list.of([1, 2, 3])")
  inspect!(ys, content="@list.of([4, 5, 6])")
  inspect!(xs.append(ys), content="@list.of([1, 2, 3, 4, 5, 6])")
}

///|
fn List::of[A](xs : FixedArray[A]) -> List[A] {
  xs |> @immut/list.of
}

///|
impl[A : Show] Show for List[A] with output(self, logger) {
  self._.output(logger)
}
