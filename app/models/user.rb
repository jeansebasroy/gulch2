class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
		#self.state = state.upcase
	before_create :create_remember_token
	
	#first name
	validates :first_name, presence: true
	
	#last name
	validates :last_name, presence: true
	
	#email
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
					uniqueness: { case_sensitive: false }

	#phone
	VALID_PHONE_REGEX = /\(?[\d]{3}\)?[\s\.-]?[\d]{3}[\s\.-]?[\d]{4}/
		#REGEX doesn't handle including a leading "1"
	validates :phone, presence: true, format: { with: VALID_PHONE_REGEX }

	#company
	validates :company, presence: true

	#address

	#city

	#state
	#VALID_STATE_REGEX = /[a-z]{2}/i
	#validates :state, format: { with: VALID_STATE_REGEX }

	#zip
	#VALID_ZIP_REGEX = /\d{5}/
	#validates :zip, format: { with: VALID_ZIP_REGEX }

	#password
	has_secure_password
	validates :password, length: { minimum: 6 }

	# Add validations / requirements for other inputs?
	#validates :phone, presence: true

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end
	
	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end

end
