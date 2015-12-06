import Data.Char(isDigit)
import Data.List(sort)

splitX :: String -> [String]
splitX s = [fst, snd, thr]
    where fst = takeWhile isDigit s
          snd = takeWhile isDigit . drop 1 $ dropWhile isDigit s
          thr = drop 1 . dropWhile isDigit . drop 1 $ dropWhile isDigit s

ribbons :: String -> Int
ribbons s = l * w * h + 2 * (min !! 0) + 2 * (min !! 1)
	where lwh = splitX s
	      l   = read $ lwh !! 0
	      w   = read $ lwh !! 1
	      h   = read $ lwh !! 2
	      min = sort [l, h, w]

main = do
	file <- readFile "../inputs/problem021.txt"
	let dimensions = lines file
	return (sum $ map ribbons dimensions)