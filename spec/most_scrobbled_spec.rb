require 'spec_helper.rb'

describe Mostscrobbled do

	context "when intializing Mostscrobbled" do
		it "should create a lastfm connection and call artists on it" do
			connection = mock(Mostscrobbled::LastFm::Connection)
			Mostscrobbled::LastFm::Connection.should_receive(:new).with(:username => "john", :api_key => "123") {connection}
			connection.should_receive(:artists)
			Mostscrobbled.find(:username => "john", :api_key => "123")
		end
	end
end