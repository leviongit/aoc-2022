import java.io.FileReader
import java.nio.CharBuffer
import scala.io.Source
import scala.language.implicitConversions

def strToRange(string: String): Range.Inclusive = {
  val Array(begin: String, end: String) = string.split('-')
  begin.toInt to end.toInt
}

implicit def int_of_bool(boolean: Boolean): Int = if (boolean) then 1 else 0

def p1(): Unit = {
  val src = Source.fromFile("in.txt")
  val lns = src.getLines

  val plst: Iterator[(Range.Inclusive, Range.Inclusive)] =
    lns.map(
      _.split(',') match {
        case Array(left: String, right: String) => (strToRange(left), strToRange(right))
        case _ => throw RuntimeException()
      }
    )

  val contains = plst.map((lr: Range.Inclusive, rr: Range.Inclusive) => rr.diff(lr).isEmpty || lr.diff(rr).isEmpty).toArray
  val amt = contains.foldLeft(0: Int)(_ + _)
  println(amt)

  src.close
}

@main
def main(): Unit = {
  p1()
}