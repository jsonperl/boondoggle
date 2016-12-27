require "benchmark"

ATTEMPTS = 100
TESTS = {
  "Plain Ruby" => "ruby random.rb 100000000",
  "Concurrent Ruby" => "ruby multicore_random.rb 100000000",
  "Concurrent go" => "go run random.go 100000000"
}

def ms(time)
  "#{(time * 1000).round}ms"
end

def stats(results)
  best = results.min
  worst = results.max
  average = results.inject(:+) / ATTEMPTS
  median = (results.sort[(ATTEMPTS - 1) / 2] + results.sort[ATTEMPTS / 2]) / 2.0

  puts "__________________"
  puts "Median:  #{ms(median)}"
  puts "Average: #{ms(average)}"
  puts "Best:    #{ms(best)}"
  puts "Worst:   #{ms(worst)}"
end

TESTS.each do |desc, command|
  puts "\n==================\n#{desc}\n==================\n"

  results = ATTEMPTS.times.map do |i|
    print "Run ##{i + 1}: "
    b = Benchmark.realtime do
      `#{command}`
    end
    puts ms(b)

    b
  end

  stats(results)
end

