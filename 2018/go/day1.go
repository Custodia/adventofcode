package main

import (
	"fmt"
	"log"
	"strconv"
	. "adventofcode2018/helper"
)

func main() {
	result1 := solvePart1()
	fmt.Printf("Result 1: %d\n", result1)
	result2 := solvePart2()
	fmt.Printf("Result 2: %d\n", result2)
}

func solvePart1() int64 {
	file, scanner := NewScanner("../inputs/day1.txt")
	defer file.Close()

	var count int64 = 0
	for scanner.Scan() {
		text := scanner.Text()
		num, err := strconv.ParseInt(text, 10, 64)
		if err != nil {
			log.Fatal(err)
		}
		count = count + num
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return count
}

func solvePart2() int64 {
	var count int64 = 0
	found := false
	set := make(map[int64]bool)

	for !found {
		file, scanner := NewScanner("../inputs/day1.txt")

		for !found && scanner.Scan() {
			text := scanner.Text()
			num, err := strconv.ParseInt(text, 10, 64)
			if err != nil {
				log.Fatal(err)
			}
			count = count + num

			if set[count] {
				found = true
			} else {
				set[count] = true
			}
		}

		if err := scanner.Err(); err != nil {
			log.Fatal(err)
		}
		file.Close()
	}

	return count
}
