package helper

import (
	"io"
	"os"
	"bytes"
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

func CountLines(filename string) int {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	buf := make([]byte, 32*1024)
	count := 0
	lineSep := []byte{'\n'}

	for {
		c, err := file.Read(buf)
		count += bytes.Count(buf[:c], lineSep)

		switch {
		case err == io.EOF:
			return count

		case err != nil:
			log.Fatal(err)
		}
	}
}

func Max(x, y int) int {
	if x > y {
		return x
	}
	return y
}
