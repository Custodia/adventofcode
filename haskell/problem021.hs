import Data.Char(isDigit)

splitX :: String -> [String]
splitX s = [fst, snd, thr]
    where fst = takeWhile isDigit s
          snd = takeWhile isDigit . drop 1 $ dropWhile isDigit s
          thr = drop 1 . dropWhile isDigit . drop 1 $ dropWhile isDigit s

area :: String -> Int
area s = 2 * lw + 2 * lh + 2 * hw + min
	where lwh = splitX s
	      l   = read $ lwh !! 0
	      w   = read $ lwh !! 1
	      h   = read $ lwh !! 2
	      lw  = l * w
	      lh  = l * h
	      hw  = h * w
	      min = minimum [lw, lh, hw]

main = do
	file <- readFile "../inputs/problem021.txt"
	let dimensions = lines file
	return (sum $ map area dimensions)