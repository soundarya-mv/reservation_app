require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  def test_index
    reservation = create_dummy_reservation
    reservations = Reservation.all
    get reservations_url
    assert_equal(reservations.to_json, response.body)
    assert_response :success
  end

  def test_reservation_create
    create_dummy_currency
    params = {
                "reservation": {
                "code": "Test1",
                "start_date": "2021-03-12",
                "end_date": "2021-03-16",
                "expected_payout_amount": "3800.00",
                "guest_details": {
                "localized_description": "4 guests",
                "number_of_adults": 2,
                "number_of_children": 2,
                "number_of_infants": 0
                },
                "guest_email": "testuser1@test.com",
                "guest_first_name": "Test",
                "guest_last_name": "User1",
                "guest_phone_numbers": [
                "1234",
                "5678"
                ],
                "listing_security_price_accurate": "500.00",
                "host_currency": "AUD",
                "nights": 4,
                "number_of_guests": 4,
                "status_type": "accepted",
                "total_paid_amount_accurate": "4300.00"
                } 
              }
    post reservations_url params: params
    response_body = JSON.parse(response.body)
    assert_equal(response_body["reservation"]["code"], params[:reservation][:code])
    assert_equal(response_body["guest"]["email"], params[:reservation][:guest_email])
    assert_equal(response.code, "200")
  end

  def test_invalid_email_create
    create_dummy_currency
    params = {
                "reservation": {
                "code": "Test2",
                "start_date": "2021-03-12",
                "end_date": "2021-03-16",
                "expected_payout_amount": "3800.00",
                "guest_details": {
                "localized_description": "4 guests",
                "number_of_adults": 2,
                "number_of_children": 2,
                "number_of_infants": 0
                },
                "guest_email": "testuser2.com",
                "guest_first_name": "Test",
                "guest_last_name": "User2",
                "guest_phone_numbers": [
                "1234",
                "56778"
                ],
                "listing_security_price_accurate": "500.00",
                "host_currency": "AUD",
                "nights": 4,
                "number_of_guests": 4,
                "status_type": "accepted",
                "total_paid_amount_accurate": "4300.00"
                } 
              }
    post reservations_url params: params
    response_body = JSON.parse(response.body)
    assert_equal(response_body, "Validation failed: Email is invalid")
    assert_equal(response.code, "400")
  end

  def test_update_reservation_details
    reservation = create_dummy_reservation({adults: 1, children: 1, start_date: Time.now(), end_date: Time.now(), status: "accepted"})
    create_dummy_currency
    params = {
                "reservation": {
                "code": reservation.code,
                "start_date": "2021-03-12T00:00:00.000Z",
                "end_date": "2021-03-12T00:00:00.000Z",
                "guest_details": {
                "localized_description": "4 guests",
                "number_of_adults": 3,
                "number_of_children": 2,
                "number_of_infants": 1
                },
                "guest_email": reservation.guest.email,
                "status": "cancelled" 
                } 
              }
    post reservations_url params: params
    response_body = JSON.parse(response.body)
    assert_equal(response_body["reservation"]["adults"], 3)
    assert_equal(response_body["reservation"]["children"], 2)
    assert_equal(response_body["reservation"]["infants"], 1)
    assert_equal(response_body["reservation"]["start_date"], "2021-03-12T00:00:00.000Z")
    assert_equal(response_body["reservation"]["end_date"], "2021-03-12T00:00:00.000Z")
    assert_equal(response.code, "200")
  end

  def create_dummy_reservation(params = {})
    guest = Guest.create(first_name: "Test", email: "testuser#{rand(100)}@test.com")
    reservation = Reservation.create(guest_id: guest.id, code: "TEST12_#{Time.now()}", start_date: params[:start_date] || Time.now(), end_date: params[:end_date] || Time.now(), status: params[:status] || "accepted", adults: params[:adults], children: params[:children])
  end

  def create_dummy_currency
    Currency.create(name: "AUD")
  end

end
