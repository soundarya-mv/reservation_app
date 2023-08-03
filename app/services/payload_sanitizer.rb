class PayloadSanitizer

	NAME_MAPPING = {code: :reservation_code, expected_payout_amount: :payout_price, listing_security_price_accurate: :security_price, total_paid_amount_accurate: :total_price, 
			host_currency: :currency_id,guest_email: :email,guest_first_name: :first_name,guest_last_name: :last_name, guest_phone_numbers: :phone_numbers, number_of_adults: :adults,
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
					final_params[mapped_param] = Currency.find_by(currency: payload).id
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