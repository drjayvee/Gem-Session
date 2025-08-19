Psych.load_file('db/gemmables.yml').each_pair do |name, attrs|
  Rubygem.find_or_create_by(name:).update!(**attrs)
end
