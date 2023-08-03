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
      # Creating the Guest object and using the primary key of parent as foreign key in the Reservation model
      guest = Guest.find_or_create_by_email(Guest.permitted_params(params[controller_name][:guest]))
      params[controller_name][:guest_id] = guest.id
      reservation = ReservationCreator.create_or_update_reservation(Reservation.permitted_params(params[controller_name]))
    rescue => e
      # Have added needed validations in the models, so when validations fail, rollback is triggered and safely captured 
      # and error response is sent back to client for their information
      render :json => e, status: 400 and return
    end
    response = { reservation: reservation, guest: reservation.guest, guest_contact_numbers: reservation.guest.guest_contact_numbers}
    response[:guest] = reservation.guest
    # As an enhancement,for the rendering of JSON output, we can make use of "Blueprinter" 
    # It helps us to define the skeleton or schema of the JSON output. It also allows different views which can be used for different usecases.
    # It also provides option to include associations, so we can add the details of parent and child class
    # As we have the skeleton defined in a single place, making changes to the response is easy as we have to make change only to that file making the code maintainable.
    # We can use blueprinter by installing the blueprinter gem "gem install blueprinter"
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
