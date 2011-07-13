module Mostscrobbled
	
	# The main call to find the artists for an account on last.fm
	# 
	# == Required paramaters
	#  * :username - A last.fm username
	#  * :api_key - A last.fm api key
	#
	def self.find(opts = {})
		begin
			Mostscrobbled::LastFm::Connection.new(opts).artists
		rescue Mostscrobbled::LastFm::Error => e
			puts e
		end
	end

end

require 'mostscrobbled/last_fm'
require 'mostscrobbled/artist'
