require "test_helper"

class GuestTest < ActiveSupport::TestCase
  def test_create_guest
    guest = Guest.create(first_name: "Test", email: "testuser#{rand(100)}@test.com")
    assert guest.persisted?
  end

  def test_create_guest_with_duplicate_email
    guest1 = Guest.create(first_name: "Test", email: "testuser#{rand(100)}@test.com")
    guest2 = Guest.create(first_name: "Test", email: guest1.email)
    assert_not_nil guest2.errors[:email]
  end

  def test_create_reservation_without_email
    guest = Guest.create(first_name: "Test")
    assert_not_nil guest.errors[:email]
  end
end
