def fibs(number)
  array = [0, 1]
  return array if number.between?(0, 1)

  array.each_index { |index| array << array[index] + array[index+1] if array.length < number } 
end

def fibs_rec(number = 0)
  return Array.new(number, 0) if number < 2
  return [0, 1] if number == 2
  
  array = fibs_rec(number - 1)
  # Base component, add previous 2 numbers starting with [0, 1] to make the third number, which is [0, 1, 1] on first iteration, repeat for each branch up
  array << array[-2] + array[-1]
end

p "Non-recursive: #{fibs(8)}"
p "Recursive: #{fibs_rec(0)}"
p "Recursive: #{fibs_rec(8)}"