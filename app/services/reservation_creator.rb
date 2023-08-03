class ReservationCreator

	def self.create_or_update_reservation(params)
		# When we have a reservation already with the given code we update the reservation with the changes in the params, else create a new reservation
		reservation = Reservation.find_by(code: params["code"])
		if reservation.nil?
			reservation = Reservation.create!(params)
		else
			reservation.update!(params)
		end
		return reservation
	end

end