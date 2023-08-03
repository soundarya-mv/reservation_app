class Reservation < ApplicationRecord
	belongs_to :guest, inverse_of: :reservations
	validates :code, presence: true, uniqueness: true
	#additional validations for date(start_date and end_date), Price(payout and security) logic can be added in future.
	def self.permitted_params(params)
      params.permit(:guest_id, :code, :start_date, :end_date, :adults, :children, :infants, :status, :currency_id, :payout_price, :security_price, :total_price)
    end
end
