package main

import (
	"os"
	"fmt"
	"log"
	"bufio"
	"strconv"
)

func main() {
	result1 := solvePart1()
	fmt.Printf("Result 1: %d\n", result1)
	result2 := solvePart2()
	fmt.Printf("Result 2: %d\n", result2)
}

func solvePart1() int64 {
	file, err := os.Open("../inputs/day1.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

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
		file, err := os.Open("../inputs/day1.txt")
		if err != nil {
			log.Fatal(err)
		}
		scanner := bufio.NewScanner(file)

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

		file.Close()
	}

	return count
}
