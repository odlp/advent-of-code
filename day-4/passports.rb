require "pry"

# Optional: cid (Country ID)

required_fields = [
  "byr", # (Birth Year)
  "iyr", # (Issue Year)
  "eyr", # (Expiration Year)
  "hgt", # (Height)
  "hcl", # (Hair Color)
  "ecl", # (Eye Color)
  "pid", # (Passport ID)
]

def valid_field?(field, value)
  case field
  when "byr"
    value.to_i.between?(1920, 2002)
  when "iyr"
    value.to_i.between?(2010, 2020)
  when "eyr"
    value.to_i.between?(2020, 2030)
  when "hgt"
    if value.include?("cm")
      value.to_i.between?(150, 193)
    elsif value.include?("in")
      value.to_i.between?(59, 76)
    end
  when "hcl"
    value.match?(/\A#[0-9a-f]{6}\z/)
  when "ecl"
    ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].include?(value)
  when "pid"
    value.match?(/\A\d{9}\z/)
  when "cid"
    true
  end
end

passports = ARGF
  .slice_when { |_, after| after == "\n" }
  .map { |lines| lines.join.gsub("\n", " ").strip }

passports_with_required_fields = passports.select do |passport|
  required_fields.all? { |field| passport.include?(field) }
end

puts "Part 1:", passports_with_required_fields.size

part_2_count = passports_with_required_fields.count do |passport|
  passport.split(" ").all? do |field_value|
    field, value = field_value.split(":")
    valid_field?(field, value)
  end
end

puts "Part 2:", part_2_count
