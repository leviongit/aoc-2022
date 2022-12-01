open System.IO

let SplitOn (elem: 'a) (ary: 'a []) : 'a [] [] =
  let rec SplitOn (acc: 'a [] []) (curr: 'a list) (list: 'a list) (elem: 'a) =
    match list with
    | e :: tail when e.Equals(elem) -> SplitOn (Array.append acc [| (Array.ofList (List.rev curr)) |]) [] tail elem
    | e :: tail -> SplitOn acc (e :: curr) tail elem
    | [] -> acc

  SplitOn [||] [] (List.ofArray ary) elem

let SplitOnDoubleNewline (string: string) : string [] [] = string.Split '\n' |> SplitOn ""

let ToNumbers (ary: string [] []) : int [] [] = Array.map (Array.map (int)) ary

let LoadFile (filename: string) : string = File.ReadAllText filename

let values =
  LoadFile "in.txt"
  |> SplitOnDoubleNewline
  |> ToNumbers
  |> Array.map (Array.sum)
  // |> Array.max
  
let singularValue = Array.max values
  
printf $"{singularValue}\n\n"

let topThree =
  Array.sort values
  |> Array.rev
  |> Array.take 3
  |> Array.sum

printf $"{topThree}\n"
