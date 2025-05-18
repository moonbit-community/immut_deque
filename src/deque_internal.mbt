///|
pub fn T::from_list[A](xs : @list.T[A]) -> T[A] {
  (List(xs), Tsil::empty())
}

///|
pub fn T::from_rev_list[A](xs : @list.T[A]) -> T[A] {
  (List::empty(), Tsil(xs))
}

///|
pub fn T::of[A](xs : FixedArray[A]) -> T[A] {
  @list.of(xs) |> from_list
}

///|
pub fn T::from_iter[A](xs : Iter[A]) -> T[A] {
  (List::empty(), @list.from_iter_rev(xs))
}

///|
pub fn T::singleton[A](x : A) -> T[A] {
  (@list.construct(x, @list.empty()), @list.empty())
}
