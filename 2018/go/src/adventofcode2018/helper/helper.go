package helper

import (
	"os"
	"log"
	"bufio"
)

func NewScanner(filename string) (*os.File, *bufio.Scanner) {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}

	scanner := bufio.NewScanner(file)

	return file, scanner
}
