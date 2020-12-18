# https://ruby-doc.org/core-2.7.2/doc/syntax/precedence_rdoc.html

module AdditionMultiplicationSamePrecedence
  refine Integer do
    def /(other)
      self + other
    end
  end

  using self

  # Division has same precedence as multiplication
  def self.calc(equation)
    eval(equation.gsub("+", "/"))
  end
end

module AdditionBeforeMultiplication
  refine Integer do
    def **(other)
      self + other
    end
  end

  using self

  # Exponent has greater precedence than multiplication
  def self.calc(equation)
    eval(equation.gsub("+", "**"))
  end
end

equations = ARGF.each_line(chomp: true).to_a

part1 = equations.sum { |equation| AdditionMultiplicationSamePrecedence.calc(equation) }
puts "Part 1:", part1

part2 = equations.sum { |equation| AdditionBeforeMultiplication.calc(equation) }
puts "Part 2:", part2
