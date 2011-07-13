require 'spec_helper.rb'

describe Mostscrobbled::Artist do
	
	context "when inititalizing an artist" do
		let(:artist) {Mostscrobbled::Artist.new(:name => "Bibio", :mbid => "123", :playcount => 200)}
		
		it "should set the name" do
			artist.name.should == "Bibio"
		end
		
		it "should set the mbid" do
			artist.mbid.should == "123"
		end
		
		it "should set the scrobbles_count" do
			artist.playcount.should == 200
		end		
	end
	
end