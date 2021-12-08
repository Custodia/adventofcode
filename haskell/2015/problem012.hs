solve :: String -> Int -> Int -> Int
solve [] _ _ = error "Basement not found"
solve (x:xs) i sum
	| sum == -1 = i
	| x == '(' = solve xs (i + 1) (sum + 1)
	| x == ')' = solve xs (i + 1) (sum - 1)
	| otherwise = error "invalid input for solve."


main = do
	file <- readFile "../../inputs/2015/problem011.txt"
	let input = (lines file) !! 0
	return (solve input 0 0)