class ContentParser

	# This method accepts a url and parses the contents.
	def parse_content_from_url(url, limit)
		fixed_url = self.fix_http(url)
		content = self.read_url(fixed_url)
		words_array = self.parse_raw_content(content)
		filtered_words = self.filter_stop_words(words_array)
		filtered_words.slice(0, limit)
	end

	# This method accepts a string and parses it. This string can come from a text area.
	def parse_content(content, limit)
		words_array = self.parse_raw_content(content)
		filtered_words = self.filter_stop_words(words_array)
		filtered_words.slice(0, limit)
	end

	def fix_http(url)
		if (url.slice(0, 4) != "http")
			url = "http://" + url
		end
		url
	end

	def read_url(url)
		# open-uri is part of the Ruby Standard Library
		# is an easy-to-use wrapper for net/http, net/https and net/ftp
		# use it to open an http, https or ftp URL as though it were a file
		require "open-uri"

		file = open(url)
		file.read
	end

	def parse_raw_content(content)
	  # strip script tags and everything in between
	  content.gsub!(/<script.*?script>/im, " ")
	  
	  # strip style tags and everything in between
	  content.gsub!(/<style.*?style>/im, " ")
	  
	  # strip all html, rails strip_tags is lame for what we want
	  # it leaves some tags in
	  content.gsub!(/<\/?[^>]+>/im, " ")
	  
	  # remove all urls
	  content.gsub!(/https?:\/\/[^\s]*/, " ")
	  
	  # split contents using a space delimiter and place results into an array
	  wordsArray = content.split(" ")

	  # remove 's etc.
	  wordsArray.map! do |word|
	    word.gsub(/\'.*$/i, " ").strip
	  end
	  
	  # remove all non alpha numeric characters from words
	  wordsArray.map! do |word|
	    word.gsub(/[^a-z\-]/i, " ").strip
	  end

	  # remove empty elements
	  wordsArray.reject! do |word|
	    word.empty?
	  end

	  # while strip_tags is working, some metadata remains - possibly javascript?
	  # as such, we may still need a manual blacklist array for clean up
	  # blacklistArray =["<div", "</div>", "<a", "<li><a"]
	  # revisedwordsArray = fullwordsArray.reject{ |e| blacklistArray.include? e }

	  # instantiate new hash to store word value
	  # and associated frequency count (to be derived below)
	  wordCountHash = Hash.new

	  # each_with_index moves array values + indexes into a hash
	  # in this case, the hash key is the word and the
	  # value is the index
	  wordsArray.each_with_index do |word, index|
	  	word.downcase!

		# checks if the word key is already present in the hash value?
		if wordCountHash.has_key?(word)
			# if true, increment by 1
			# Question for Hamid?  what specifically are we incrementing by 1 or seeting = 1?
			wordCountHash[word] += 1
		else
			# if false, start at 1
			wordCountHash[word] = 1
		end
	  end

	  # instantiate a new array, and sort our hash
	  # the sort method uses the <=> comparison operator
	  # the reuslting array will look like [k1, v1, k2, v2, k3, v3]
	  wordCountPairArray = wordCountHash.sort do |left, right|
	    # Question for Hamid?  I still don"t totally understand the below line.
	    right[1] <=> left[1]
	  end

	  wordCountPairArray
	end

	def filter_stop_words(words_array)
		stop_words = ["a", "to", "the", "and", "in", "on", 
			"for", "you", "at", "no", "yes", "of", "now", 
			"more", "out", "can", "that", "says", "with",
			"will", "sorry", "only", "his", "are", "sat",
			"all", "nbsp", "do", "sign", "near", "i m", "is",
			"use", "as", "also", "an", "this", "name", "who",
			"by", "i", "or", "may", "form", "may", "have",
			"been", "our", "us", "say", "get", "other",
			"has", "x", "from", "-p", "-", "inc", "one"]
		filtered_words_array = words_array.reject do |e|
			# binding.pry
			stop_words.include? e[0].to_s.downcase
		end
		filtered_words_array
	end

end