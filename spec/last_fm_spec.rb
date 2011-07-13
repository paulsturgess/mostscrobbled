require 'spec_helper.rb'

describe Mostscrobbled::LastFm::Connection do
	
	before { FakeWeb.allow_net_connect = false }
	after  { FakeWeb.allow_net_connect = true }
	
	let(:connection) {Mostscrobbled::LastFm::Connection.new(:username => "johnsmith", :api_key => "023456789")}
	
	
	context "when intializing a connection with valid argument" do
		it "should set the username" do
			connection.username.should == "johnsmith"
		end
		it "should set the api_key" do
			connection.api_key.should == "023456789"
		end	
	end

	context "when initializing a connection without the username argument" do
		it "should raise an exception" do
			lambda {Mostscrobbled::LastFm::Connection.new(:api_key => "123")}.should raise_exception(Mostscrobbled::LastFm::ConfigError)
		end
	end
	
	context "when initializing a connection without the api_key argument" do
		it "should raise an exception" do
			lambda {Mostscrobbled::LastFm::Connection.new(:username => "John")}.should raise_exception(Mostscrobbled::LastFm::ConfigError)
		end
	end
	
	describe "artists_uri" do
		context "when not providing a page number" do
			it "should set the artists uri without a page number" do
				connection.artists_uri.should == URI.parse("http://ws.audioscrobbler.com/2.0/?method=library.getartists&api_key=023456789&user=johnsmith")
			end
		end
		context "when providing a page number" do
			it "should set the artists uri with a page number" do
				connection.artists_uri(2).should == URI.parse("http://ws.audioscrobbler.com/2.0/?method=library.getartists&api_key=023456789&user=johnsmith&page=3")
			end
		end
	end
	
	# Note that you cannot compare two Nokogiri documents that have been parsed, even if you are parsing the same document
	# In any case we're not testing that Nokogiri works, we're testing that Nokogiri is called with the correct options
	describe "artists_xml" do
		context "when the result is ok" do
			before do
				FakeWeb.register_uri(:get, "http://example.com", :body => File.read("spec/fixtures/artists_ok.xml"))
				connection.stub(:artists_uri){URI.parse("http://example.com")}
			end
			it "should call the artists url with Nokogiri parse to get the xml" do
				Nokogiri::XML::Document.should_receive(:parse).with(Net::HTTP.get(URI.parse("http://example.com")), nil, nil, 1)
				connection.artists_xml
			end
			it "should not raise the error message as an exception" do
				lambda {connection.artists_xml}.should_not raise_exception(Mostscrobbled::LastFm::ResponseError)
			end
		end
		context "when the result is failed" do
			before do
				FakeWeb.register_uri(:get, "http://example.com", :body => File.read("spec/fixtures/artists_failed.xml"), :status => ["403", "Forbidden"])
				connection.stub(:artists_uri){URI.parse("http://example.com")}
			end
			it "should raise the a ResponseError exception" do
				lambda {connection.artists_xml}.should raise_exception(Mostscrobbled::LastFm::ResponseError)
			end
		end
	end
	
	describe "total_artist_pages" do
		before { connection.stub(:artists_xml).and_return(Nokogiri::XML(File.read("spec/fixtures/artists_ok.xml"))) }
		it "should return the correct number of pages" do
			connection.total_artist_pages.should == 1
		end
	end

	describe "artists" do
		before do
			connection.stub(:total_artist_pages){1}
			connection.stub(:artists_xml).and_return(Nokogiri::XML(File.read("spec/fixtures/artists_ok.xml")))
		end
		it "should include the artists returned by artists_xml" do
			connection.artists.map(&:name).should include("Bibio")
			connection.artists.map(&:name).should include("Bonobo")
			connection.artists.first.should be_kind_of(Mostscrobbled::Artist)
			connection.artists.length.should == 2
		end
	end

end