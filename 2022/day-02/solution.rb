# frozen_string_literal: true

BASE_MAPPING = { "A" => :rock, "B" => :paper, "C" => :scissors }
MAPPING_PART_1 = BASE_MAPPING.merge({ "X" => :rock, "Y" => :paper, "Z" => :scissors })
MAPPING_PART_2 = BASE_MAPPING.merge({ "X" => :loss, "Y" => :draw, "Z" => :win })
SCORES = { rock: 1, paper: 2, scissors: 3, loss: 0, draw: 3, win: 6 }

WINNING_PLAYS = [
  [:rock, :scissors],
  [:scissors, :paper],
  [:paper, :rock],
]

def parse_rounds(input, mapping)
  input.map { |round| mapping.values_at(round[0], round[-1]) }
end

def score_round(play_1, play_2)
  outcome = if (play_1 == play_2)
    :draw
  elsif WINNING_PLAYS.include?([play_1, play_2])
    :loss
  else
    :win
  end

  SCORES.fetch(outcome) + SCORES.fetch(play_2)
end

def pick_play(play_1, desired_outcome)
  case desired_outcome
  when :draw then [play_1, play_1]
  when :loss then WINNING_PLAYS.detect { |win, _loss| win == play_1 }
  when :win  then WINNING_PLAYS.detect { |_win, loss| loss == play_1 }.reverse
  else raise "Unknown outcome: #{desired_outcome}"
  end
end

lines = ARGF.readlines(chomp: true)
puts "Part 1:", parse_rounds(lines, MAPPING_PART_1).sum { |round| score_round(*round) }
puts "Part 2:", parse_rounds(lines, MAPPING_PART_2).sum { |round| score_round(*pick_play(*round)) }
