require 'bcrypt'

class User

	include DataMapper::Resource

	attr_reader :password
	attr_accessor :password_confirmation

	# this is datamapper's method of validating the model.
	# The model will not be saved unless both password
	# and password_confirmation are the same
	# read more about it in the documentation
	# http://datamapper.org/docs/validations.html
	
	validates_confirmation_of :password
	
	

	property :id, 	  				 Serial
	property :email, 				 String, :unique => true, :message => "This email is already taken"
	property :password_digest, 		 Text
	
	


	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def self.authenticate(email, password)
		#that's the user who is tyring to sign in
		user = first(:email => email)
		#if this user exits and the password provided matches
		#
		#The password.new returns an object that overrides the ==
		#method. Instead of comparing two passwords directly
		#(which is impossible because we only have a one-way hash)
		#the password given and compares it to the password_digest
		#it was initialized with.
		#So, to recap: THIS IS NOT A STRING COMPARISON
		if user && BCrypt::Password.new(user.password_digest) == password#return this user
			user
		else
			nil
		end
end
end