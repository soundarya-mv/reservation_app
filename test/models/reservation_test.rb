require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  def test_create_reservation
    guest = Guest.create(first_name: "Test", email: "testuser#{rand(100)}@test.com")
    reservation = Reservation.create(guest_id: guest.id, code: "TEST12_#{Time.now()}", start_date: Time.now(), end_date: Time.now(), status: "accepted", adults: 2, children: 1)
    assert reservation.persisted?
  end

  def test_create_reservation_without_guest
    reservation = Reservation.create(code: "TEST12_#{Time.now()}", start_date: Time.now(), end_date: Time.now(), status: "accepted", adults: 2, children: 1)
    assert_not_nil reservation.errors[:guest]
  end

  def test_create_reservation_with_duplicate_reservation_code
    guest = Guest.create(first_name: "Test", email: "testuser#{rand(100)}@test.com")
    reservation1 = Reservation.create(guest_id: guest.id, code: "TEST12_#{Time.now()}", start_date: Time.now(), end_date: Time.now(), status: "accepted", adults: 2, children: 1)
    reservation2 = Reservation.create(guest_id: guest.id, code: reservation1.code, start_date: Time.now(), end_date: Time.now(), status: "accepted", adults: 2, children: 1)
    assert_not_nil reservation2.errors[:code]
  end

  def test_create_reservation_without_reservation_code
    guest = Guest.create(first_name: "Test", email: "testuser#{rand(100)}@test.com")
    reservation = Reservation.create(guest_id: guest.id, start_date: Time.now(), end_date: Time.now(), status: "accepted", adults: 2, children: 1)
    assert_not_nil reservation.errors[:code]
  end
end
