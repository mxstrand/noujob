class WelcomeController < ApplicationController
	before_filter :authenticate_user!, except: [:index, :aboutus]
	
	def index
  	@comparison = Url.new
	end

  	def aboutus
  	end

	def match_urls
		u = Url.new
		u.job_seeker_url = params[:job_seeker_url]
		u.job_descrip_url = params[:job_descrip_url]
		u.save

		content_parser = ContentParser.new
		@job_seeker_url_words = content_parser.parse_content_from_url(u.job_seeker_url, 25)
		@job_descrip_url_words = content_parser.parse_content_from_url(u.job_descrip_url, 25)

		@highest_count = 0
		@job_seeker_url_words.each do |w|
			if w[1] > @highest_count
				@highest_count = w[1]
			end
		end
		@job_descrip_url_words.each do |w|
			if w[1] > @highest_count
				@highest_count = w[1]
			end
		end
	end

	def match_content
		content_parser = ContentParser.new
		@job_seeker_url_words = content_parser.parse_content(params[:job_seeker_profile], 25)
		@job_descrip_url_words = content_parser.parse_content(params[:job_descrip], 25)
		
		@highest_count = 0
		@job_seeker_url_words.each do |w|
			if w[1] > @highest_count
				@highest_count = w[1]
			end
		end
		@job_descrip_url_words.each do |w|
			if w[1] > @highest_count
				@highest_count = w[1]
			end
		end
	end

end
