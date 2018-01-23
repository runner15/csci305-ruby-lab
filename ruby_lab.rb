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
$name = "Zachariah Fahsi"
$total = 0
# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "
	begin
		all = {}
		IO.foreach(file_name) do |line|
			# do something for each line
			title = cleanup_title(line)
			unless title.nil?
				gram = title.split().each_cons(2).to_a
				gram = gram.map{ |n| n.join(' ') }
  				gram = gram.each_with_object(Hash.new(0)) { |word, obj| obj[word.downcase] += 1 }
  				if gram.any?
	  				all.merge!(gram) { |k, old, new| old + new }
	  			end
			end
			if $total==-20
				break
			end
		end
		$bigrams = all.sort_by { |k, v| -v }
		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

def cleanup_title(title)
	title.sub!(/^[^_]*<SEP>/, '')
	title.sub!(/\(.*$|\[.*$|\{.*$|\\.*$|\/.*$|\-.*$|\:.*$|\".*$|\`.*$|\+.*$|\=.*$|\*.*$|feat\..*$/, '')
	title.sub!(/[?¿!¡\.;&@%#\|]/, '')
	title.downcase!
	if ( title =~ /^[\w\s\d']+$/ )
	   	$total=$total+1
	   	title
	end	
end

def mcw(word)
	$bigrams.each do |search| 
		find = "#{search[0].split.first}" 
		if word == find
			return search[0].split.last
		end
	end
	return "No Matches!"
end

def allWords(word)
	count = 0
	$bigrams.each do |search| 
		find = "#{search[0].split.first}" 
		if word == find
			puts "#{search}"
			count = count + 1
		end
	end
	puts "#{count}"
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
	#puts "#{$total}"
	while true
		puts "Enter a word [Enter 'q' to quit]:"
		word = STDIN.gets.sub!(/[^\w]+$/,'')
		if word == "q"
			break
		end
		#common = mcw(word)
		#puts "#{common}"
		allWords(word)
	end
end

main_loop()
