package main

import (
	"fmt"
	"log"
	"math"
	"strings"
	. "adventofcode2018/helper"
)

const fileName string = "../inputs/day6.txt"

type coord struct {
	x int
	y int
}

func main() {
	result1 := solvePart1()
	fmt.Printf("Result 1: %d\n", result1)
	result2 := solvePart2()
	fmt.Printf("Result 2: %d\n", result2)
}

func solvePart1() int {
	count, unfittedCoords := parseInput()
	extraRows := 1

	maxx, maxy, coords := fitCoords(unfittedCoords, extraRows)

	grid := make([][]int, maxx + 1)
	for x := 0; x <= maxx; x++ {
		row := make([]int, maxy + 1)
		grid[x] = row
		for y := 0; y <= maxy; y++ {
			minDist := math.MaxInt32
			closest := -1
			for i, c := range coords {
				dist := intAbs(x - c.x) + intAbs(y - c.y)
				if dist < minDist {
					minDist = dist
					closest = i
				} else if dist == minDist {
					closest = -1
				}
			}
			row[y] = closest
		}
	}

	infinite := make(map[int]bool)
	for x := 0; x <= maxx; x++ {
		infinite[grid[x][0]] = true
		infinite[grid[x][maxy]] = true
	}
	for y := 0; y <= maxx; y++ {
		infinite[grid[0][y]] = true
		infinite[grid[maxx][y]] = true
	}

	areas := make([]int, count)
	for x := 0; x <= maxx; x++ {
		for y := 0; y <= maxy; y++ {
			area := grid[x][y]
			if area != -1 {
				areas[area] += 1
			}
		}
	}
	for k, v := range infinite {
		if v && k != -1 {
			areas[k] = -1
		}
	}
	maxv := 0
	for _, v := range areas {
		if v > maxv {
			maxv = v
		}
	}

	return maxv
}

func solvePart2() int {
	_, unfittedCoords := parseInput()
	extraRows := 0

	maxx, maxy, coords := fitCoords(unfittedCoords, extraRows)

	region := 0
	for x := 0; x <= maxx; x++ {
		for y := 0; y <= maxy; y++ {
			total := 0
			for _, c := range coords {
				dist := intAbs(x - c.x) + intAbs(y - c.y)
				total += dist
			}
			if total < 10000 {
				region += 1
			}
		}
	}

	return region
}

func fitCoords(coords []coord, extraRows int) (int, int, []coord) {
	minx, miny, maxx, maxy := math.MaxInt32, math.MaxInt32, 0, 0

	for _, c := range coords {
		minx = Min(minx, c.x)
		miny = Min(miny, c.y)
		maxx = Max(maxx, c.x)
		maxy = Max(maxy, c.y)
	}

	xa, ya := minx - extraRows, miny - extraRows
	minx, miny, maxx, maxy = 0, 0, maxx - xa, maxy - ya

	for i, c := range coords {
		coords[i] = coord{x: c.x - xa, y: c.y - ya}
	}

	return maxx, maxy, coords
}

func parseInput() (int, []coord) {
	lineCount := CountLines(fileName)
	file, scanner := NewScanner(fileName)
	defer file.Close()

	coords := make([]coord, lineCount)
	i := 0
	for scanner.Scan() {
		c := strings.Split(scanner.Text(), ", ")
		coords[i] = coord{x: StringToInt(c[0]), y: StringToInt(c[1])}
		i++
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}


	return lineCount, coords
}

func intAbs(a int) int {
	if a < 0 {
		return -a
	}
	return a
}
