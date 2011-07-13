require 'nokogiri'
require 'open-uri'
require 'net/http'

module Mostscrobbled
	module LastFm
		class Error < StandardError; end
		class ResponseError < Error; end
		class ConfigError < Error; end
		class Connection
				
			REQUIRED_ATTRIBUTES = :username, :api_key
			attr_accessor *(REQUIRED_ATTRIBUTES)
			
			def initialize(opts = {})
				raise ConfigError, missing_options(opts).map{ |argument| ":#{argument} argument missing" }.join(" and ") unless missing_options(opts).empty?
				opts.each{ |key,value| send("#{key}=", value) }
			end
			
			# Returns an array of MostscrobbledArtist objects
			def artists
				(artists = []).tap do 
					total_artist_pages.times do |page|
						artists_xml(page).xpath('//artist').collect do |node|
							artists << Mostscrobbled::Artist.build_artist(node)
						end
					end
				end
			end
		
			# The uri used to call the last.fm api
			def artists_uri(page_number = nil)
				URI.parse("http://ws.audioscrobbler.com/2.0/?method=library.getartists&api_key=#{api_key}&user=#{username}#{"&page=#{page_number + 1}" if page_number}")
			end
		
		  # The parsed XML returned from the last.fm api
			def artists_xml(page_number = nil)
				uri = artists_uri(page_number)
				http = Net::HTTP.new(uri.host)
				request = Net::HTTP::Get.new(uri.request_uri)
				response = http.request(request)
				case response.code
				when "200"
					@artists_xml ||= {}
					@artists_xml[page_number || 0] ||= Nokogiri::XML(response.body)
				when "403"
					raise ResponseError, Nokogiri::XML(response.body).xpath(".//error").first.content.inspect
				end
			end
		
		  # The total number of pages returned by the last.fm api
			def total_artist_pages
				artists_xml.xpath('//artists').first["totalPages"].to_i
			end
			
			private

			def missing_options(opts)
				REQUIRED_ATTRIBUTES.select{ |argument| opts[argument].nil? }
			end

		end
	
	end
end