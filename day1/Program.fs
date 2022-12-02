open System.IO

let SplitOnDoubleNewlineAndConvertToInt (string: string) : int[][] =
  string.Split "\n\n"
  |> Array.map (fun s -> Array.map int (s.Split '\n'))



let inline LoadFile (filename: string) : string = File.ReadAllText filename

let values =
  LoadFile "in.txt"
  |> SplitOnDoubleNewlineAndConvertToInt
  |> Array.map (Array.sum)
  
let singularValue = Array.max values
  
printf $"{singularValue}\n\n"

let topThree =
  Array.sort values
  |> Array.rev
  |> Array.take 3
  |> Array.sum

printf $"{topThree}\n"
