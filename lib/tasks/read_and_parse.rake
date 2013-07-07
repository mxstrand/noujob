namespace :getjob do
  desc "gets data from internet and parses it"
  task getdata: :environment do
    read_and_parse_page
  end
end

def read_and_parse_page
  require "open-uri"

  file = open("http://stackoverflow.com/questions/1854207/getting-webpage-content-with-ruby-im-having-troubles")
  contents = file.read
  fullwordsArray = contents.split(' ')
  # puts wordsArray

  blacklistArray =["<div", "</div>", "<a", "<li><a"]

  revisedwordsArray = fullwordsArray.reject{ |e| blacklistArray.include? e }

  wordCountHash = Hash.new

  revisedwordsArray.each_with_index do |word, index|

  if wordCountHash.has_key?(word)
    wordCountHash[word] += 1
    else
      wordCountHash[word] = 1
    end
  end

  wordCountPairArray = wordCountHash.sort do |left, right|
  right[1] <=> left[1]
  end

  wordCountPairArray.each do |element|
  puts "#{element[1]} \t\t #{element[0]}"
  end
end

# DEVELOPMENT
# rake getjob:getdata
