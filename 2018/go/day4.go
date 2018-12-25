package main

import (
	"fmt"
	"log"
	"regexp"
	"sort"
	. "adventofcode2018/helper"
)

const fileName string = "../inputs/day4.txt"

var regex *regexp.Regexp = regexp.MustCompile(`^\[(\d{4}-(\d\d)-(\d\d) (\d\d):(\d\d))\] (.+)$`)
var guardRegex *regexp.Regexp = regexp.MustCompile(`^Guard #(\d+) begins shift$`)

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
	asleep := parseInput()

	guard := 0
	max := 0
	for k, v := range asleep {
		total := 0
		for _, minutes := range v {
			total += minutes
		}
		if (total > max) {
			guard = k
			max = total
		}
	}

	minute := 0
	max = 0
	for i, v := range asleep[guard] {
		if v > max {
			minute = i
			max = v
		}
	}

	fmt.Printf("Guard: %d\n", guard)
	fmt.Printf("Minute: %d\n", minute)

	return guard * minute
}

func solvePart2() int {
	asleep := parseInput()

	guard := 0
	minute := 0
	max := 0
	for k, v := range asleep {
		for i, w := range v {
			if (w > max) {
				guard = k
				minute = i
				max = w
			}
		}
	}

	fmt.Printf("Guard: %d\n", guard)
	fmt.Printf("Minute: %d\n", minute)

	return guard * minute
}

func parseInput() map[int][60]int {
	lineCount := CountLines(fileName)
	file, scanner := NewScanner(fileName)
	defer file.Close()

	inputLines := make([]inputLine, lineCount)
	i := 0
	for scanner.Scan() {
		inputLines[i] = parseLine(scanner.Text())
		i++
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	sort.Slice(inputLines, func (i, j int) bool {
		return inputLines[i].date < inputLines[j].date
	})

	guard := 0
	asleep := make(map[int][60]int)
	for i, v := range inputLines {
		switch v.text {
		case "falls asleep":
		case "wakes up":
			w := inputLines[i - 1]
			if w.text != "falls asleep" || w.month != v.month || w.day != v.day || w.hour != 0 || v.hour != 0 || w.minute >= v.minute {
				fmt.Printf("%04d %v", i - 1, w)
				fmt.Printf("%04d %v", i    , v)
				log.Fatal("Input lines don't fall into expectations")
			}
			for j := w.minute; j < v.minute; j++ {
				x := asleep[guard]
				x[j] += 1
				asleep[guard] = x
			}
		default:
			result := guardRegex.FindStringSubmatch(v.text)
			guard = StringToInt(result[1])
		}
	}

	return asleep
}

func parseLine(line string) inputLine {
	result := regex.FindStringSubmatch(line)
	month  := StringToInt(result[2])
	day    := StringToInt(result[3])
	hour   := StringToInt(result[4])
	minute := StringToInt(result[5])
	date   := result[1]
	text   := result[6]
	return inputLine{month: month, day: day, hour: hour, minute: minute, date: date, text: text}
}
