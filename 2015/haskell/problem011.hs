solve :: String -> Int
solve [] = 0
solve (x:xs)
	| x == '(' = (solve xs) + 1
	| x == ')' = (solve xs) - 1
	| otherwise = error "invalid input for solve."


main = do
	file <- readFile "../inputs/problem011.txt"
	let input = (lines file) !! 0
	return (solve input)