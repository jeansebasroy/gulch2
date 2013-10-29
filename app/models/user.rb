class User < ActiveRecord::Base
	has_many :sites

	before_save { self.email = email.downcase }
		#self.state = state.upcase
	before_create :create_remember_token
	
	validates :first_name, presence: true									#first name
	validates :last_name, presence: true									#last name	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 				#email
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },	#email
					uniqueness: { case_sensitive: false }					#email
	VALID_PHONE_REGEX = /\(?[\d]{3}\)?[\s\.-]?[\d]{3}[\s\.-]?[\d]{4}/		#phone
		#REGEX doesn't handle including a leading "1"
	validates :phone, presence: true, format: { with: VALID_PHONE_REGEX }	#phone
	validates :company, presence: true										#company
																			#address
																			#city
	#VALID_STATE_REGEX = /[a-z]{2}/i 										#state
	#validates :state, format: { with: VALID_STATE_REGEX }					#staet
	#VALID_ZIP_REGEX = /\d{5}/ 												#zip
	#validates :zip, format: { with: VALID_ZIP_REGEX }						#zip
	has_secure_password														#password
	validates :password, length: { minimum: 6 }								#password

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
