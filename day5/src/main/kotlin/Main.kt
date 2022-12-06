import java.io.File

fun <T> transpose(a: List<List<T>>): List<List<T>> {
  val rowl = a.size
  val coll = a.first().size

  if (!a.all { it.size == coll }) throw IllegalArgumentException()

  return List(coll) { x -> List(rowl) { y -> a[y][x] } }
}

fun readData(input: String): List<List<Char>> {
  val data = input.lines()

  val padLength = ((data.last().length / 4) + 1) * 4

  return transpose(data.dropLast(1).map { ln ->
    ln.padEnd(padLength, ' ').chunked(4).map { it[1] }
  }).map { row -> row.filter { !it.isWhitespace() }.toMutableList() }
}

class Instr(private val count: Int, private val from: Int, private val to: Int) {
  companion object {
    fun decode(string: String): Instr {
      val (count, from, to) = string.split(" ").filterIndexed { idx, _ -> idx % 2 == 1 }.map { it.toInt() }
      return Instr(count, from - 1, to - 1)
    }
  }

  fun execute(state: List<List<Char>>, cm9001: Boolean): List<List<Char>> {
    return List(state.size) { idx ->
      when (idx) {
        to -> state[from].take(count).let {
          if (cm9001) {
            it
          } else {
            it.reversed()
          }
        } + state[to]

        from -> state[from].drop(count)
        else -> state[idx]
      }
    }
  }
}

fun applyInstrs(state: List<List<Char>>, instrs: List<Instr>, cm9001: Boolean): List<List<Char>> {
  return instrs.fold(state) { a, i -> i.execute(a, cm9001) }
}

fun p1(state: List<List<Char>>, instrs: List<Instr>) {
  println(applyInstrs(state, instrs, false).map { it.first() }.joinToString(""))
}

fun p2(state: List<List<Char>>, instrs: List<Instr>) {
  println(applyInstrs(state, instrs, true).map { it.first() }.joinToString(""))
}

fun main() {
  val fileContents = File("in.txt").readText()

  val (state, instrs) = fileContents.split("\n\n").let { (data, instrs) ->
    Pair(readData(data), instrs.lines().map { Instr.decode(it) })
  }

  p1(state, instrs)
  p2(state, instrs)
}

