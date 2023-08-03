class Reservation < ApplicationRecord
	belongs_to :guest, inverse_of: :reservations
	validates :reservation_code, uniqueness: true

	def self.permitted_params(params)
      params.permit(:guest_id, :reservation_code, :start_date, :end_date, :adults, :children, :infants, :status, :currency_id, :payout_price, :security_price, :total_price)
    end
end
