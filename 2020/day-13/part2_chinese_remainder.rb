# https://rosettacode.org/wiki/Chinese_remainder_theorem#Ruby

def solve_chinese_remainder(mods, remainders)
  max = mods.inject(:*)  # product of all moduli
  series = remainders.zip(mods).map{ |r,m| (r * max * invmod(max/m, m) / m) }
  series.inject(:+) % max
end

def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end
  return last_remainder, last_x * (a < 0 ? -1 : 1)
end

def invmod(e, et)
  g, x = extended_gcd(e, et)
  if g != 1
    raise 'Multiplicative inverse modulo does not exist!'
  end
  x % et
end

bus_ids_offsets = ARGF.readlines(chomp: true)[1].split(",").map.with_index do |bus_id, index|
  if bus_id != "x"
    [bus_id.to_i, index * -1]
  end
end.compact.to_h

puts "Part 2:", solve_chinese_remainder(bus_ids_offsets.keys, bus_ids_offsets.values)
