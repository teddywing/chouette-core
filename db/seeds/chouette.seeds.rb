path = File.join(File.expand_path('../seeds', __FILE__), "*.rb")

Dir.glob(path).sort.each do |file|
  puts "Seed #{file}"
  load file
end
