 module Test where


 main :: IO ()
 main = readLn >>= print . func

 func :: Int -> String
 func n =
   case n of
     2 -> show 2
     3 -> show 5
     _ -> show 8
