package main

import "fmt"

func main() {
	fmt.Print ("Enter lenght in meters: ")
	var lenght float64
	fmt.Scanf ("%f", &lenght)
	fmt.Printf ("%.2f meters is %.2f feet\n", lenght, lenght/0.3048)
}
