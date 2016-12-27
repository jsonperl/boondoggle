require "etc"

class MulticoreRandom
  def initialize
    @dataset = File.readlines("data").map(&:to_i).freeze

    @pids = []
    @readers = []
  end

  # Brute force recursive
  def compute(goal, dataset)
    element = dataset.delete_at(rand(dataset.length))

    if element < goal
      compute(goal - element, dataset).push(element)
    else
      [element]
    end
  end

  def run(goal)
    Etc.nprocessors.times do
      reader, writer = IO.pipe
      @readers << reader

      @pids << fork do
        Signal.trap("HUP") { exit }
        Signal.trap("INT") { } # let the parent process cleanup

        reader.close

        loop do
          answer = compute(goal, @dataset.dup)

          if answer.reduce(0, :+) == goal
            Marshal.dump(answer, writer)
            break
          end
        end
      end

      writer.close
    end

    ready, _, _ = IO.select(@readers)
    complete(ready[0].read)
  ensure
    cleanup
  end

   # For this excercise, we'll just write to stdout
  def complete(answer)
    puts Marshal.load(answer).sort
  end

  # Kill the sub-processes
  def cleanup
    @pids.each { |pid| Process.kill("HUP", pid) } rescue nil
  end
end

mr = MulticoreRandom.new
mr.run(ARGV[0].to_i)
