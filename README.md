# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
	ruby-3.0.0
* System dependencies

* Configuration

* Database creation

  	2 Databases:

	Development: Reservation

	Test: Reservation_test

	rails db:migrate RAILS_ENV=development

	rails db:migrate RAILS_ENV=test

* Database initialization

  	4 tables:

  		Guests

  		Reservations

  		Guest_contact_numbers

  		Currencies

	DB entries for currencies table: - Could have been enum in the code. But in Future while we scale to other currencies we can just introduce by adding an entry to the table, without code change

  		INSERT INTO Currencies(currency, created_at, updated_at) VALUES ("AUD", '2023-08-03 15:04:08', '2023-08-03 15:04:08');

  		INSERT INTO Currencies(currency, created_at, updated_at) VALUES ("INR", '2023-08-03 15:04:08', '2023-08-03 15:04:08');

  		INSERT INTO Currencies(currency, created_at, updated_at) VALUES ("USD", '2023-08-03 15:04:08', '2023-08-03 15:04:08');

  		INSERT INTO Currencies(currency, created_at, updated_at) VALUES ("GBP", '2023-08-03 15:04:08', '2023-08-03 15:04:08');

* How to run the test suite

	rails test test/controllers/reservations_controller_test.rb

	rails test test/models/guest_test.rb

	rails test test/models/reservation_test.rb

* Curl command to hit the post endpoint:

	Payload 1:
		curl -v -H "Content-Type: application/json" -X POST -d '{"reservation_code": "TEST1","start_date": "2023-07-25", "end_date":"2023-07-27", "nights": 3, "guests": 4,"adults": 2,"children": 2,"infants": 0,"status": "accepted","guest": {"first_name": "Test","last_name": "User1","phone": "12345", "email": "testuser1@test.com"},"currency": "AUD","payout_price": "4200.00","security_price": "500","total_price": "4710.00"}' 'http://127.0.0.1:3000/reservations'


	Payload 2:
		curl -v -H "Content-Type: application/json" -X POST -d '{"reservation": {"code": "TEST2", "start_date": "2023-07-15", "end_date": "2023-07-17", "expected_payout_amount": "3800.00", "guest_details": { "localized_description": "4 guests", "number_of_adults": 3, "number_of_children": 3, "number_of_infants": 1}, "guest_email": "testuser2@test.com", "guest_first_name": "Test", "guest_last_name": "User2", "guest_phone_numbers": ["1234", "5678"], "listing_security_price_accurate": "500.00", "host_currency": "USD", "nights": 4, "number_of_guests": 5, "status_type": "accepted", "total_paid_amount_accurate": "4300.00"} }' 'http://127.0.0.1:3000/reservations'

