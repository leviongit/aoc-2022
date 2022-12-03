let to_priority c =
  match c with
  | 'a' .. 'z' -> Char.code c - Char.code 'a' + 1
  | 'A' .. 'Z' -> Char.code c - Char.code 'A' + 27
  | _ -> -1

let str_to_halves str =
  let half = String.length str / 2 in
  (String.sub str 0 half, String.sub str half half)

module CharSet = Set.Make (Char)
module IntSet = Set.Make (Int)

let halves_to_sets (fst, snd) =
  (CharSet.of_seq (String.to_seq fst), CharSet.of_seq (String.to_seq snd))

let common (s1, s2) = CharSet.inter s1 s2

let charset_to_priority_intset set =
  IntSet.of_seq (Seq.map to_priority (CharSet.to_seq set))

let ( << ) f g x = f (g x)
let readall = In_channel.input_all << In_channel.open_text

let p1 () =
  let vals = readall "in.txt" in
  let lines = List.map String.trim (String.split_on_char '\n' vals) in
  print_string "Part 1: ";
  print_int
    (List.fold_left
       (fun acc str ->
         IntSet.fold ( + )
           ((charset_to_priority_intset << common << halves_to_sets
           << str_to_halves)
              str)
           0
         + acc)
       0 lines);
  print_newline ()

let () = p1 ()
