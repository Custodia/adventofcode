package main

import (
	. "adventofcode2018/helper"
	"fmt"
	"log"
	"regexp"
	"strconv"
)

const fileName string = "../../inputs/2018/day3.txt"

var regex *regexp.Regexp = regexp.MustCompile(`^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$`)

func main() {
	result1 := solvePart1()
	fmt.Printf("Result 1: %d\n", result1)
	result2 := solvePart2()
	fmt.Printf("Result 2: %d\n", result2)
}

func solvePart1() int {
	_, claims := parseInput()
	maxx, maxy := countDimensions(claims)
	fabric := createFabric(maxx, maxy)

	for _, c := range claims {
		x, y, xx, yy := c[1], c[2], c[3], c[4]
		for i := 0; i < xx; i++ {
			for ii := 0; ii < yy; ii++ {
				fabric[x+i][y+ii] += 1
			}
		}
	}

	count := 0
	for x := 0; x < maxx; x++ {
		for y := 0; y < maxy; y++ {
			if fabric[x][y] > 1 {
				count++
			}
		}
	}

	return count
}

func solvePart2() int {
	lineCount, claims := parseInput()
	maxx, maxy := countDimensions(claims)
	fabric := createFabric(maxx, maxy)

	collisions := make([]bool, lineCount)
	for _, c := range claims {
		id, x, y, xx, yy := c[0], c[1], c[2], c[3], c[4]
		for i := 0; i < xx; i++ {
			for ii := 0; ii < yy; ii++ {
				prevId := fabric[x+i][y+ii]
				if prevId != 0 {
					collisions[id-1] = true
					collisions[prevId-1] = true
				} else {
					fabric[x+i][y+ii] = id
				}
			}
		}
	}

	result := 0
	for k, v := range collisions {
		if !v {
			result = k + 1
			break
		}
	}

	return result
}

func parseInput() (int, [][5]int) {
	lineCount := CountLines(fileName)
	file, scanner := NewScanner(fileName)
	defer file.Close()

	claims := make([][5]int, lineCount)
	i := 0
	for scanner.Scan() {
		claims[i] = parseLine(scanner.Text())
		i++
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return lineCount, claims
}

func parseLine(text string) [5]int {
	result := [5]int{}
	a := regex.FindStringSubmatch(text)
	for i, v := range a {
		if i == 0 {
			continue
		}
		e, err := strconv.Atoi(v)
		if err != nil {
			log.Fatal(err)
		}
		result[i-1] = e
	}
	return result
}

func countDimensions(vector [][5]int) (int, int) {
	maxx, maxy := 0, 0
	for _, c := range vector {
		maxx = Max(maxx, c[1]+c[3])
		maxy = Max(maxy, c[2]+c[4])
	}
	return maxx, maxy
}

func createFabric(maxx, maxy int) [][]int {
	fabric := make([][]int, maxx)
	for i := range fabric {
		fabric[i] = make([]int, maxy)
	}
	return fabric
}
