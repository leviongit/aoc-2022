let ( << ) f g x = f (g x)
let curry f fst snd = f (fst, snd)

let conseq n l =
  let rec conseq acc cl n l =
    match l with
    | x :: xs when List.length cl < n -> conseq acc (x :: cl) n xs
    | x :: xs -> conseq (cl :: acc) [ x ] n xs
    | [] -> cl :: acc
  in

  List.rev (List.map List.rev (conseq [] [] n l))

let foldl1 f l =
  let rec foldl1 acc f l =
    match l with x :: xs -> foldl1 (f acc x) f xs | [] -> acc
  in
  match l with x :: xs -> foldl1 x f xs | [] -> raise (Invalid_argument "")

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

let charset_of_string = CharSet.of_seq << String.to_seq

let halves_to_sets (fst, snd) =
  (CharSet.of_seq (String.to_seq fst), CharSet.of_seq (String.to_seq snd))

let common (s1, s2) = CharSet.inter s1 s2

let charset_to_priority_intset =
  IntSet.of_seq << Seq.map to_priority << CharSet.to_seq

let readall = In_channel.input_all << In_channel.open_text
let lines = String.split_on_char '\n' << String.trim

let p1 () =
  let str = readall "in.txt" in
  let lines = lines str in
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

let p2 () =
  (* List.iter print_str_lst (conseq 3 [ "a"; "b"; "c"; "d"; "e"; "f" ]) *)
  let lines' = lines (readall "in.txt") in
  let triples = conseq 3 lines' in
  let cs_triples = List.map (List.map charset_of_string) triples in
  let intersects = List.map (foldl1 (curry common)) cs_triples in
  let value =
    List.fold_left
      (fun acc e -> acc + to_priority (CharSet.choose e))
      0 intersects
  in
  print_string "Part 2: ";
  print_int value;
  print_newline ()

let () =
  p1 ();
  p2 ()
