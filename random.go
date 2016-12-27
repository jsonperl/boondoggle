package main

import (
  "fmt"
  "io"
  "math/rand"
  "os"
  "runtime"
  "strconv"
  "sort"
  "time"
)

func compute(goal int, dataSet []int, generator *rand.Rand) []int{
  index := generator.Intn(len(dataSet))
  element := dataSet[index]

  if element < goal {
    dataSet = append(dataSet[:index], dataSet[index+1:]...)
    return append(compute(goal - element, dataSet, generator), element)
  } else {
    return []int{element}
  }
}

func main() {
  runtime.GOMAXPROCS(runtime.NumCPU())

  goal, _ := strconv.Atoi(os.Args[1])
  dataSet := getData("data")
  channel := make(chan []int)

  for i := 0; i < runtime.NumCPU(); i++ {
    go func() {
      generator := rand.New(rand.NewSource(time.Now().UnixNano()))

      for {
        dupe := make([]int, len(dataSet))
        copy(dupe, dataSet)

        answer := compute(goal, dupe, generator)
        if sum(answer) == goal {
          channel <- answer
          break
        }
      }
    }()
  }

  complete(<-channel)
}

func complete(answer []int) {
  sort.Ints(answer)

  for _, a := range answer {
    fmt.Println(a)
  }
}

func getData(filePath string) (numbers []int) {
  fd, _ := os.Open(filePath)
  var line int
  for {
    _, err := fmt.Fscanf(fd, "%d\n", &line)
    if err == io.EOF {
      return
    }
    numbers = append(numbers, line)
  }

  return
}

func sum(nums []int) int{
  total := 0
  for _, num := range nums {
    total += num
  }
  return total
}
