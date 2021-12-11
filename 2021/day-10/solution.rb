PAIRS = { "(" => ")", "[" => "]", "{" => "}", "<" => ">" }
ERROR_SCORES = { ")" => 3, "]" => 57, "}" => 1_197, ">" => 25_137 }
AUTOCOMPLETE_SCORES = { ")" => 1, "]" => 2, "}" => 3, ">" => 4 }
SINGLE_PAIR_CHUNK = Regexp.union(*PAIRS.map(&:join))

def part1(lines)
  illegal_chars = []

  unbalanced_lines = lines.filter do |line|
    unbalanced = false
    stack = []

    line.each do |char|
      if PAIRS.key?(char) # Opening-bracket
        stack.append(char)
      elsif stack.empty? # Incomplete line
        break
      elsif PAIRS.key(char) != stack.pop # Mismatch closing-bracket
        illegal_chars << char
        unbalanced = true
        break
      end
    end

    unbalanced
  end

  [unbalanced_lines, illegal_chars]
end

def part2(incomplete_lines)
  line_completions = autocomplete_lines(incomplete_lines)
  scores = autocomplete_score(line_completions)
  scores.sort[(scores.size / 2)]
end

def autocomplete_lines(incomplete_lines)
  incomplete_lines.map do |incomplete_line|
    unmatched = collapse_matching_pairs(incomplete_line.join)
    unmatched.chars.reverse_each.map { |char| PAIRS.fetch(char) }
  end
end

# Recursively collapse bracket-pairs until there are no more substitutions
def collapse_matching_pairs(sequence)
  if sequence.gsub!(SINGLE_PAIR_CHUNK, "").nil?
    sequence
  else
    collapse_matching_pairs(sequence)
  end
end

def autocomplete_score(line_completions)
  line_completions.map do |line_completion|
    line_completion.reduce(0) do |score, char|
      (score * 5) + AUTOCOMPLETE_SCORES.fetch(char)
    end
  end
end

lines = ARGF.readlines(chomp: true).map(&:chars)
unbalanced_lines, illegal_chars = part1(lines)
puts "Part 1:", illegal_chars.sum { |char| ERROR_SCORES.fetch(char) }

incomplete_lines = (lines - unbalanced_lines)
puts "Part 2:", part2(incomplete_lines)
