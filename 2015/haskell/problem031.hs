import Data.List(nub)

data Coord = Coord { x :: Int
			 , y :: Int 
			 } deriving (Show, Eq)

coords :: String -> [Coord]
coords s = coordsHelper s (Coord 0 0) []

coordsHelper :: String -> Coord -> [Coord] -> [Coord]
coordsHelper [] c cs = c : cs
coordsHelper (z:zs) c cs
	| z == '^' = coordsHelper zs (Coord cx (cy + 1)) (c : cs)
	| z == '<' = coordsHelper zs (Coord (cx - 1) cy) (c : cs)
	| z == '>' = coordsHelper zs (Coord (cx + 1) cy) (c : cs)
	| z == 'v' = coordsHelper zs (Coord cx (cy - 1)) (c : cs)
	| otherwise = error "invalid char"
	where cx = x c
	      cy = y c

main = do
	file <- readFile "../inputs/problem031.txt"
	let input = (lines file) !! 0
	return (length . nub $ coords input)