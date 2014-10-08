require 'spec_helper'

feature 'User signs up' do
	#strictly speaking the test that checks the UI(have_content, etc)
	#should be seperate from the tests that check what we have in the database
	#reason is that you should test one thing at a tme whereas by mixing the two
	#we are testing both the business logic and the views
	#however,lets not worry about this yet
	#to keep the example simple

	scenario "when being logged out" do
		expect{sign_up}.to change(User, :count).by 1
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq ("alice@example.com")

	end

	def sign_up(email = "alice@example.com", password = "oranges!")
		visit '/users/new'
		expect(page.status_code).to eq 200
		fill_in :email, :with => email
		fill_in :password, :with => password
		click_button "Sign up"
	end


end