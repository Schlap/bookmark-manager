require 'spec_helper'

describe Link do
	
	context "Demonstration of how datamapper works" do

		#this is not a real test, its simply a demo of how it works

		it "should be created and then retreived from the database" do
			#In the beginning our database is empty, so there are no links
			expect(Link.count).to eq (0)
			#this creates it in the database, so it's stored on the disk
			Link.create(:title => "Makers Academy", 
						:url => "http://www.makersacademy.com/")
			#We ask the database how many links we have, it should be 1
			#expect(Link.count).to eq (1)
			#lets get the first and only link from the database
			link = Link.first
			#now it has all the properties that it will save with
			expect(link.url).to eq "http://www.makersacademy.com/"
			expect(link.title).to eq  "Makers Academy"
			#if we want to, we can destroy it
			link.destroy
			expect(Link.count).to eq (0)
		end
	end

end