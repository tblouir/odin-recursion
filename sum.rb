array = [1, 2, 3, 4]

def sum_integers(array, length = array.length-1)
  return nil if array.empty?

  return array[0] if length == 0

  return array[length] + sum_integers(array, length-1)
end

p sum_integers(array)

# 4 + (3 + (2 + (1)))
# When length == 0, array[0] + sum_integers(array, -1)
# which then goes to array[-1] + sum_integers(array, -2)
# basically infinite 'nil' after it gets past negative array length of -4