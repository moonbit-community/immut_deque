///|
fn benchmark_cons_snoc() -> Unit {
  let crit = @bm.Criterion::new()
  let n = 10000
  let count = 100
  crit.add(
    @bm.Task::new(
      "deque::cons",
      fn() {
        let mut d = @immut_deque.empty()
        for i in 0..<n {
          d = d.cons(i)
        }
      },
      count~,
    ),
  )
  crit.add(
    @bm.Task::new(
      "deque::snoc",
      fn() {
        let mut d = @immut_deque.empty()
        for i in 0..<n {
          d = d.snoc(i)
        }
      },
      count~,
    ),
  )
  crit.add(
    @bm.Task::new(
      "deque::cons/snoc",
      fn() {
        let mut d = @immut_deque.empty()
        for i in 0..<(n / 2) {
          d = d.cons(i)
        }
        for i in 0..<(n / 2) {
          d = d.snoc(i)
        }
      },
      count~,
    ),
  )
  crit.add(
    @bm.Task::new(
      "list::add",
      fn() {
        let mut l = @immut/list.Nil
        for i in 0..<n {
          l = @immut/list.Cons(i, l)
        }
      },
      count~,
    ),
  )
  let r = crit.run()
  println(r["deque::cons"])
  println(r["deque::snoc"])
  println(r["deque::cons/snoc"])
  println(r["list::add"])
}

///|
fn benchmark_immut_mut() -> Unit {
  let crit = @bm.Criterion::new()
  let n = 10000
  let count = 100
  crit.add(
    @bm.Task::new(
      "immut_deque::cons/snoc",
      fn() {
        let mut d = @immut_deque.empty()
        for i in 0..<n {
          d = d.cons(i)
        }
        for i in 0..<n {
          d = d.snoc(i)
        }
      },
      count~,
    ),
  )
  crit.add(
    @bm.Task::new(
      "deque::push_front/push_back",
      fn() {
        let d = @deque.new()
        for i in 0..<n {
          d.push_front(i)
        }
        for i in 0..<n {
          d.push_back(i)
        }
      },
      count~,
    ),
  )
  let r = crit.run()
  println(r["immut_deque::cons/snoc"])
  println(r["deque::push_front/push_back"])
}

test "benchmark" {

}
