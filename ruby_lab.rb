
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Zachariah Fahsi
# zachariah.fahsi@student.montana.edu
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$bigramsArray = Hash.new
$name = "Zachariah Fahsi"
$total = 0
# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		all = Hash.new
		IO.foreach(file_name) do |line|
			# do something for each line
			title = cleanup_title(line)
			unless title.nil?
				gram = title.split().each_cons(2).to_a
				gram = gram.map{ |n| n.join(' ') }
  				gram = gram.each_with_object(Hash.new(0)) { |word, obj| obj[word] += 1 }
  				if gram.any?
	  				all.merge!(gram) { |k, old, new| old + new }
	  			end
			end
		end
		$bigramsArray = all.sort_by { |k, v| -v }
		create_hash()
		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

def cleanup_title(title)
	title.gsub!(/.*(?<=>)/, '')
	title.gsub!(/\(.*|{.*|\[.*|\\.*|\/.*|_.*|-.*|`.*|\+.*|=.*|\*.*|feat..*|:.*|".*/, '')
	title.gsub!(/[?!¿¡\.;&@%#\|]/, '')
  	if !(title =~ /^[\w\s\d']+$/)
    	title.clear
  	end
  	title.downcase!
  	title.gsub!(/\b(a|an|and|by|for|from|in|of|on|or|out|the|to|with)\b/,'')
  	title
end

def mcw(word)
	$bigramsArray.each do |search| 
		find = "#{search[0].split.first}" 
		if word == find
			return search[0].split.last
		end
	end
	""
end

def allWords(word)
	count = 0
	$bigramsArray.each do |search| 
		find = "#{search[0].split.first}" 
		if word == find
			puts "#{search}"
			count = count + 1
		end
	end
	puts "#{count}"
end

def create_title(word)
	count = 0
	create = mcw(word)
	newTitle = word
	#while (count<19 && create != "No Matches")
	#	newTitle = newTitle + " " + create
	#	create = mcw(create)
	#	count = count + 1
	#end
	while true
		break if newTitle.include? create
		newTitle = newTitle + " " + create
		create = mcw(create)
	end
	newTitle
end

def create_hash()
	$bigramsArray.each do |search| 
		first = "#{search[0].split.first}" 
		last  = "#{search[0].split.last}" 
		value = "#{search[1]}".to_i
		if $bigrams["#{first}"]
			$bigrams["#{first}"].merge!({last => value})
		else
			$bigrams.merge!(first => {last => value})
		end
	end
end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])
	# Get user input
	while true
		puts "Enter a word [Enter 'q' to quit]:"
		word = STDIN.gets.sub!(/[^\w]+$/,'')
		if word == "q"
			#puts "#{$bigrams.size}"
			break
		end
	#	common = mcw(word)
	#	puts "#{common}"
	#	allWords(word)
		puts "#{create_title(word)}"
	end
end

if __FILE__==$0
	main_loop()
end
