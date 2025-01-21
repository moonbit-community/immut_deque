test "cons" {
  let xs = [] |> of
  let xs = xs.cons(1).cons(2).cons(3).cons(4).cons(5)
  inspect!(xs, content="@deque.of([5, 4, 3, 2, 1])")
}

test "snoc" {
  let xs = [] |> of
  let xs = xs.snoc(1).snoc(2).snoc(3).snoc(4).snoc(5)
  inspect!(xs, content="@deque.of([1, 2, 3, 4, 5])")
}

test "of" {
  let xs = [1, 2, 3, 4, 5] |> of
  inspect!(xs, content="@deque.of([1, 2, 3, 4, 5])")
}

test "cons/snoc" {
  let xs = [] |> of
  let xs = xs.cons(1).snoc(2).cons(3).snoc(4)
  inspect!(xs, content="@deque.of([3, 1, 2, 4])")
}

test "cons/snoc-2" {
  let xs = [1, 2, 3, 4, 5, 6] |> of
  inspect!(xs.cons(99), content="@deque.of([99, 1, 2, 3, 4, 5, 6])")
  inspect!(xs.snoc(99), content="@deque.of([1, 2, 3, 4, 5, 6, 99])")
}

test "uncons/empty" {
  let empty : T[Int] = of([])
  inspect!(empty.uncons(), content="None")
}

test "uncons/single" {
  let single = of([1])
  inspect!(single.uncons(), content="Some((1, @deque.of([])))")
}

test "uncons/multiple" {
  let d = of([1, 2, 3, 4, 5])
  let (head, rest) = d.uncons().unwrap()
  inspect!(head, content="1")
  inspect!(rest, content="@deque.of([2, 3, 4, 5])")
}

test "unsnoc/empty" {
  let empty : T[Int] = of([])
  inspect!(empty.unsnoc(), content="None")
}

test "unsnoc/single" {
  let d = of([1])
  inspect!(d.unsnoc(), content="Some((1, @deque.of([])))")
}

test "unsnoc/multiple" {
  let d = of([1, 2, 3])
  inspect!(d.unsnoc(), content="Some((3, @deque.of([1, 2])))")
}

test "append" {
  let xs = [] |> of
  let ys = [] |> of
  let xs = xs.cons(1).snoc(2)
  let ys = ys.cons(3).snoc(4)
  let zs = xs.append(ys)
  inspect!(xs, content="@deque.of([1, 2])")
  inspect!(ys, content="@deque.of([3, 4])")
  inspect!(zs, content="@deque.of([1, 2, 3, 4])")
}

///|
let xs : T[Int] = of([]).cons(2).cons(1).snoc(3).snoc(4)

test {
  inspect!(xs, content="@deque.of([1, 2, 3, 4])")
}

test "map" {
  inspect!(
    xs.map(fn(x) { [x, x * 11] |> of }),
    content="@deque.of([@deque.of([1, 11]), @deque.of([2, 22]), @deque.of([3, 33]), @deque.of([4, 44])])",
  )
}

test "bind" {
  inspect!(
    xs.bind(fn(x) { [x, x * 11] |> of }),
    content="@deque.of([1, 11, 2, 22, 3, 33, 4, 44])",
  )
}

test "iter/rev_iter" {
  inspect!(xs.iter(),content="[1, 2, 3, 4]")
  inspect!(xs.rev_iter(),content="[4, 3, 2, 1]")
}