class ReservationsController < ApplicationController
  protect_from_forgery with: :null_session
  wrap_parameters format: [:json], exclude: [:controller, :action]
  before_action :sanitize_payload, only: :create

  def index
    reservations = Reservation.includes(:guest).all
    render :json => reservations
  end

  def create
    begin
      guest = Guest.find_or_create_by_email(Guest.permitted_params(params[controller_name][:guest]))
      params[controller_name][:guest_id] = guest.id
      reservation = ReservationCreator.create_or_update_reservation(Reservation.permitted_params(params[controller_name]))
    rescue => e
      render :json => e, status: 400 and return
    end
    response = { reservation: reservation, guest: reservation.guest, guest_contact_numbers: reservation.guest.guest_contact_numbers}
    response[:guest] = reservation.guest
    render :json => response, status: 200
  end

  private
    def sanitize_payload
      controller_name = params["controller"].singularize
      sanitized_payload = PayloadSanitizer.new().sanitize_payload(params[controller_name])
      params[controller_name] = sanitized_payload
    end

    def controller_name
      controller_name = params["controller"].singularize
    end
end
