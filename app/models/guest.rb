class Guest < ApplicationRecord

	validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, on: :create
	has_many :reservations, dependent: :destroy, inverse_of: :guest
	has_many :guest_contact_numbers, dependent: :destroy
	accepts_nested_attributes_for :guest_contact_numbers

	def self.find_or_create_by_email(params)
		return Guest.find_by(email: params[:email]) || Guest.create!(params)
	end

	def self.permitted_params(params)
    	params.permit(:first_name, :email, :last_name, guest_contact_numbers_attributes: [:contact_number])
    end
end
