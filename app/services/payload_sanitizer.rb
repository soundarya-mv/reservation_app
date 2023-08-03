class PayloadSanitizer

	# We have this mapping to rename the attribute which we get in params, to what that param actually means in our System
	# For example payout_price can be sent in params as expected_payout_amount, payout_amount, accomodation_price etc. 
	# So creating a mapping helps us to be flexible with the params which we receive from the client.
	# Also we can be flexible with the structure of the payload as we are finally sanitizing it into a single hash structure to process the creation/updation the reservation record
	# It also has the logic to know the Guest model data, so guest can be saved independently before reservation.
	# We have separate currencies table.Could have been enum in the code. But in Future while we scale to other currencies we can just introduce by adding an entry to the table, without code change
	NAME_MAPPING = {reservation_code: :code, expected_payout_amount: :payout_price, listing_security_price_accurate: :security_price, total_paid_amount_accurate: :total_price, 
			host_currency: :currency_id, currency: :currency_id, guest_email: :email,guest_first_name: :first_name,guest_last_name: :last_name, guest_phone_numbers: :phone_numbers, number_of_adults: :adults,
		 	number_of_children: :children, number_of_infants: :infants, status_type: :status, phone: :phone_numbers, number: :phone_numbers, contact_number: :phone_numbers}
	GUEST_CONSTANTS = [:first_name, :last_name, :email]
	GUEST_CONTACT_CONSTANTS = [:phone_numbers]
	CURRENCY_CONSTANT = [:currency_id]
	STATUS_CONSTANT = {"accepted": 1, "cancelled": 2}

	def sanitize_payload(received_payload)
		final_params = {}
		received_payload.each do |param, payload|
			if payload.is_a?(ActionController::Parameters)
				hash_params = sanitize_payload(payload)
				final_params.merge!(hash_params)
			else
				mapped_param = name_mapping(param)
				if(mapped_param.in?(GUEST_CONSTANTS))
					(final_params[:guest] ||= {}).merge!({(mapped_param) => payload})
				elsif(mapped_param.in?(GUEST_CONTACT_CONSTANTS))
					(final_params[:guest] ||= {}).merge!(guest_contact_numbers_attributes: [])
					Array.wrap(payload).each do |number|
						(final_params[:guest][:guest_contact_numbers_attributes] ||= []).append({contact_number: number})
					end
				elsif(mapped_param.in?(CURRENCY_CONSTANT))
					final_params[mapped_param] = Currency.find_by(name: payload).id
				elsif(mapped_param == :status)
					final_params[mapped_param] = STATUS_CONSTANT[payload.to_sym]
				else
					final_params[mapped_param] = payload
				end
			end
		end
		return final_params
	end

	private
		def name_mapping(param_name)
			NAME_MAPPING["#{param_name}".to_sym] || "#{param_name}".to_sym
		end

end