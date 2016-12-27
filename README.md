## Boondoggle!

# Exercise
The 2010 Census puts populations of 26 largest US metro areas at 18897109, 12828837, 9461105, 6371773, 5965343, 5946800, 5582170, 5564635, 5268860, 4552402, 4335391, 4296250, 4224851, 4192887, 3439809, 3279833, 3095313, 2812896, 2783243, 2710489, 2543482, 2356285, 2226009, 2149127, 2142508, and 2134411.

Can you find a subset of these areas where a total of exactly 100,000,000 people live, assuming the census estimates are exactly right? Provide the answer and code or reasoning used.

# Goals
I'm off this week and want to get my feet wet with [golang](https://golang.org/). Rather than consider this an excercise in efficient algorithm design, I wanted to see if I could create a very naive and small ruby solution that would run in a reasonable amount of time and then see what I can achieve by throwing more cpu cycles at it, first in ruby and then go. I tried my best to write essentially the same algorithm in go, but since this is pretty much my "hello world" go app, I had to take some liberties.

# Platforms
* Ruby - MRI 2.3.1 (yes I'm aware 2.4 just shipped)
* go - 1.7.4

# Gotchas (got mes?)
Calls to `rand` in go use a global Rand object that has a mutex lock associated with it. It's really ineffective for concurrent use. Each coroutine needs its own Random number generator. My initial concurrent go solution was 33% slower than the concurrent ruby solution. With that fixed, the go solution is the fastest by far.

# Results
Theres a small [test wrapper](https://github.com/jsonperl/boondoggle/blob/master/test.rb) to run each version 100 times. I have a 4 core machine (8 if you count Hyperthreads). Running each version, the median performance was as follows:

* Ruby Solution:  9816ms
* Concurrent Ruby Solution: 2264ms
* Concurrent go Solution: 539ms

Check out detailed run results here [here](https://github.com/jsonperl/boondoggle/blob/master/results.txt)

# Takeaways
Concurrency in go is a complete piece of cake. Coroutines and channels are super intuitive, and the wiring for them is extremely minimal. Concurrency in ruby has always been quite challenging. EVERYTHING else that needed to be done here was easier and quicker to build with Ruby, but that's not at all shocking. Also I don't know go at all yet, so there's that.
