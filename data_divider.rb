results = {}

for letter in 'A'..'Z' do
  results[letter] = []
end

training = File.open('training_data.csv', 'w')
test = File.open('test_data.csv', 'w')

File.open('letter-recognition.data', 'r') do |f|
  f.each_line do |l|
    results[l[0]].push(l)
  end
end

results.keys.each do |letter|
  instance_count = results[letter].length
  for i in 0...(instance_count / 2)
    training.puts results[letter][i]
  end

  for i in (instance_count / 2)...instance_count
    test.puts results[letter][i]
  end
end

training.close
test.close
