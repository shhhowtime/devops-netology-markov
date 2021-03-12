package main

import "fmt"

func main() {
	var mas = []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17}
	var min, lenght int
	min = 65535
	lenght = len(mas)
	for i := 0; i < lenght; i++ {
		if min > mas[i] {
			min = mas[i]
		}
	}
	fmt.Printf ("Minimal element of massive is %d\n", min)
}
