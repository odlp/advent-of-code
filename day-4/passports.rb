#!/usr/bin/env ruby

REQUIRED_FIELDS = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
VALID_EYE_COLORS = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

def valid_field?(field, value)
  case field
  when "byr" then value.to_i.between?(1920, 2002)
  when "iyr" then value.to_i.between?(2010, 2020)
  when "eyr" then value.to_i.between?(2020, 2030)
  when "hcl" then value.match?(/\A#[0-9a-f]{6}\z/)
  when "ecl" then VALID_EYE_COLORS.include?(value)
  when "pid" then value.match?(/\A\d{9}\z/)
  when "cid" then true
  when "hgt"
    if value.include?("cm")
      value.to_i.between?(150, 193)
    elsif value.include?("in")
      value.to_i.between?(59, 76)
    end
  end
end

passports = ARGF
  .slice_when { |_, after| after == "\n" }
  .map { |lines| lines.join.gsub("\n", " ").strip }

passports_with_required_fields = passports.select do |passport|
  REQUIRED_FIELDS.all? { |field| passport.include?(field) }
end

required_and_valid_count = passports_with_required_fields.count do |passport|
  passport.split(" ").all? do |field_value|
    field, value = field_value.split(":")
    valid_field?(field, value)
  end
end

puts "Part 1:", passports_with_required_fields.count
puts "Part 2:", required_and_valid_count
