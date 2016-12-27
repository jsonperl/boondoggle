dataset = File.readlines("data").map(&:to_i)
goal = ARGV[0].to_i

def compute(goal, dataset)
  element = dataset.delete_at(rand(dataset.length))

  if element < goal
    compute(goal - element, dataset).push(element)
  else
    [element]
  end
end

loop do
  answer = compute(goal, dataset.dup)
  if answer.reduce(0, :+) == goal
    puts answer.sort
    break
  end
end
