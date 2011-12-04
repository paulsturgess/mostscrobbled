module Mostscrobbled
	class Artist
		
		attr_accessor :name, :playcount, :tagcount, :mbid, :url, :streamable, :image_small, :image_medium, :image_large, :image_extralarge, :image_mega
		
		def initialize(attrs = {}, *args) 
	    super(*args)
	    attrs.each { |key,value| send("#{key}=", value) }
	  end
		
		# Creates an instance of Mostscrobbled::Artist from an xml node returned by the last.fm api
		def self.build_artist(node)
			(artist = Artist.new).tap do
				[:name, :playcount, :tagcount, :mbid, :url, :streamable].each do |attribute|
					artist.send("#{attribute}=", node.xpath(".//#{attribute}").first.content)
				end
				node.xpath(".//image").each do |image_node| # set :image_small, :image_medium, :image_large, :image_extralarge, :image_mega
					artist.send("image_#{image_node.attributes["size"].value}=", image_node.children.first.content) if image_node.children.first
				end
			end
		end
		
		# Returns a hash of all the attributes with their names as keys and the values of the attributes as values.
		def attributes
		  Hash[instance_variables.map { |name| [name[1..-1].to_sym, instance_variable_get(name)] }]
		end
		
	end	
end