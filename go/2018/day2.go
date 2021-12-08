package main

import (
	. "adventofcode2018/helper"
	"fmt"
	"log"
	"sort"
)

const fileName string = "../../inputs/2018/day2.txt"

func main() {
	result1 := solvePart1()
	fmt.Printf("Result 1: %d\n", result1)
	result2 := solvePart2()
	fmt.Printf("Result 2: %s\n", result2)
}

func solvePart1() int {
	count2, count3 := 0, 0
	file, scanner := NewScanner(fileName)
	defer file.Close()

	for scanner.Scan() {
		m := make(map[rune]int)
		twos, threes := false, false
		text := scanner.Text()
		for _, rune := range text {
			m[rune] = m[rune] + 1
		}
		for _, value := range m {
			twos = twos || value == 2
			threes = threes || value == 3
			if twos && threes {
				break
			}
		}
		if twos {
			count2 += 1
		}
		if threes {
			count3 += 1
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return count2 * count3
}

func solvePart2() string {
	lineCount := CountLines(fileName)
	file, scanner := NewScanner(fileName)
	defer file.Close()

	slice := make([]string, lineCount)
	i := 0
	for scanner.Scan() {
		slice[i] = scanner.Text()
		i++
	}

	sort.Strings(slice)
	i = 0
	result := ""
	for i, str := range slice {
		nextStr := []rune(slice[i+1])
		commonChars := []rune{}
		for ii, rune := range str {
			if rune == nextStr[ii] {
				commonChars = append(commonChars, rune)
			}
		}
		if len(commonChars)+1 == len(str) {
			result = string(commonChars)
			break
		}
		i++
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return result
}
