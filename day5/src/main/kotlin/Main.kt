import java.io.File


fun <T> transpose(a: List<List<T>>): List<List<T>> {
  val rowl = a.size
  val coll = a.first().size

  if (!a.all { it.size == coll }) throw IllegalArgumentException()

  return MutableList(coll) { x -> MutableList(rowl) { y -> a[y][x] } }
}

fun readData(input: String): List<MutableList<Char>> {
  val data = input.lines()

  val padLength = ((data.last().length / 4) + 1) * 4

  return transpose(data.dropLast(1).map { ln ->
    ln.padEnd(padLength, ' ').chunked(4).map { it[1] }
  }).map { row -> row.filter { !it.isWhitespace() }.toMutableList() }
}

class Instr(val count: Int, val from: Int, val to: Int) {
  companion object {
    fun decode(string: String): Instr {
      val (count, from, to) = string.split(" ").filterIndexed { idx, _ -> idx % 2 == 1 }.map { it.toInt() }
      return Instr(count, from - 1, to - 1)
    }
  }

  fun execute(state: List<MutableList<Char>>): List<MutableList<Char>> {
//    val dat = slst.take(count)
//    state[from] = slst.drop(count).toMutableList()
//    state[to] = (dat + dlst).toMutableList();
    return List(state.size) {
      when (it) {
        to -> state[from].take(count).reversed() + state[to]
        from -> state[from].drop(count)
        else -> state[it]
      }.toMutableList()
    }
  }
}

fun applyInstrs(state: List<MutableList<Char>>, instrs: List<Instr>): List<MutableList<Char>> {
  return instrs.fold(state) { a, i -> i.execute(a) }
}

fun p1(state: List<MutableList<Char>>, instrs: List<Instr>) {
  println(applyInstrs(state, instrs).map { it.first() }.joinToString(""))
}

fun main() {
  val fileContents = File("in.txt").readText()

  val (state, instrs) = fileContents.split("\n\n")
    .let { (data, instrs) -> Pair(readData(data), instrs.lines().map { Instr.decode(it) }) }

  p1(state, instrs)
}

