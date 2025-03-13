///|
pub fn T::from_list[A](xs : @immut/list.T[A]) -> T[A] {
  (List(xs), Tsil(Nil))
}

///|
pub fn T::from_rev_list[A](xs : @immut/list.T[A]) -> T[A] {
  (List(Nil), Tsil(xs))
}

///|
pub fn T::of[A](xs : FixedArray[A]) -> T[A] {
  xs |> @immut/list.of |> from_list
}

///|
pub fn T::from_iter[A](xs : Iter[A]) -> T[A] {
  (List::empty(), @immut/list.from_iter_rev(xs))
}

///|
pub fn T::singleton[A](x : A) -> T[A] {
  (Cons(x, Nil), Nil)
}
