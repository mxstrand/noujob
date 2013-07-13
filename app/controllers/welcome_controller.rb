class WelcomeController < ApplicationController

	def index
  		@comparison = Url.new
	end

	def match
		u = Url.new
		u.job_seeker_url = params[:job_seeker_url]
		u.job_descrip_url = params[:job_descrip_url]
		u.save

		@job_seeker_url_words = read_and_parse_page(u.job_seeker_url, 20)
		@job_descrip_url_words = read_and_parse_page(u.job_descrip_url, 20)
	end

end

def read_and_parse_page(url, limit)
  # open-uri is part of the Ruby Standard Library
  # is an easy-to-use wrapper for net/http, net/https and net/ftp
  # use it to open an http, https or ftp URL as though it were a file
  require "open-uri"

  file = open(url)
  contents = file.read
  
  # strip script tags and everything in between
  contents.gsub!(/<script.*?script>/im, " ")
  
  # strip style tags and everything in between
  contents.gsub!(/<style.*?style>/im, " ")
  
  # strip all html, rails strip_tags is lame for what we want
  # it leaves some tags in
  contents.gsub!(/<\/?[^>]+>/im, " ")
  
  # remove all urls
  contents.gsub!(/https?:\/\/[^\s]*/, " ")
  
  # split contents using a space delimiter and place results into an array
  wordsArray = contents.split(" ")
  
  # remove all non alpha numeric characters from words
  wordsArray.map! do |word|
    word.gsub(/[^a-z]/i, " ").strip
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
    # Question for Hamid?  I still don't totally understand the below line.
    right[1] <=> left[1]
  end

  wordCountPairArray.slice(0, limit)
end
