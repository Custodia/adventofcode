package main

import (
	"fmt"
	"log"
	"strings"
	. "adventofcode2018/helper"
)

const fileName string = "../inputs/day5.txt"

type inputLine struct {
	month int
	day int
	hour int
	minute int
	date string
	text string
}

func main() {
	result1 := solvePart1()
	fmt.Printf("Result 1: %d\n", result1)
	result2 := solvePart2()
	fmt.Printf("Result 2: %d\n", result2)
}

func solvePart1() int {
	input := parseInput()
	polymer := []rune(input)

	return reactedLength(polymer)
}

func solvePart2() int {
	input := parseInput()
	polymer := []rune(input)
	result := len(polymer)

	for i := 0; i + 'A' <= 'Z'; i++ {
		char := rune(i + 'A')
		filteredPolymer := filterUnits(polymer, char)
		length := reactedLength(filteredPolymer)
		if length < result {
			result = length
		}
	}

	return result
}

func reactedLength(polymer []rune) int {
	prevLen, length := -1, len(polymer)
	for length != prevLen {
		prevLen = length
		length, polymer = filterAdjacent(polymer)
	}

	return len(polymer)
}

func filterUnits(runes []rune, char rune) []rune {
	count := 0
	result := make([]rune, len(runes))
	for _, v := range runes {
		if v != char && v != char + 32 {
			result[count] = v
			count++
		}
	}
	return result[:count]
}

func filterAdjacent(runes []rune) (int, []rune) {
	count := 0
	length := len(runes)
	prev := false
	result := make([]rune, len(runes))
	for i, v := range runes {
		if i == 0 {
			continue
		}
		w := runes[i - 1]
		if prev {
			prev = false
			if i == length - 1 {
				result[count] = v
				count++
			}
			continue
		}
		if (w - v == 32 || v - w == 32) {
			if (strings.ToLower(string(w)) != strings.ToLower(string(v)) || v == w) {
				log.Fatal("v and w are not the same letter")
			}
			prev = true
			continue
		}
		result[count] = w
		count++
		if i == length - 1 {
			result[count] = v
			count++
		}
	}
	return count, result[:count]
}

func parseInput() string {
	file, scanner := NewScanner(fileName)
	defer file.Close()

	scanner.Scan()

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return scanner.Text()
}
