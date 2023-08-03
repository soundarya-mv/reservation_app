class ReservationCreator

	def self.create_or_update_reservation(params)
		reservation = Reservation.find_by(reservation_code: params["reservation_code"])
		if reservation.nil?
			reservation = Reservation.create!(params)
		else
			reservation.update!(params)
		end
		return reservation
	end

end