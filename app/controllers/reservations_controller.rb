class ReservationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_property, only: [:new, :preview, :create]
    
    def index
        @reservations = current_user.reservations.includes(:property).order(created_at: :desc)
        @number_of_nights=nil
        @total_price=nil
    end
    
    def show
        @reservation = Reservation.find(params[:id])
    end
    
    def new
        @property = Property.find(params[:property_id])
        @reservation = Reservation.new
        if params[:reservation]
            @reservation.assign_attributes(preview_params)
        end
        @number_of_nights = nil
        @total_price = nil
    end
    
    def preview
        @reservation = Reservation.new(preview_params)
        @reservation.property = @property
        @reservation.user = current_user
        
        unless @reservation.valid?
            flash.now[:alert] = @reservation.errors.full_messages.join(", ")
            render :new, status: :unprocessable_entity
            return
        end
        
        if @reservation.checkin_date && @reservation.checkout_date
            @number_of_nights = (@reservation.checkout_date - @reservation.checkin_date).to_i
        else
            @number_of_nights = 0
        end
        
        if @property.price && @number_of_nights > 0
            @total_price = @property.price * @number_of_nights
        else
            @total_price = Money.new(0, @property.price_currency || "USD")
        end
        
        render :preview
    end
    
    def create
        @reservation = current_user.reservations.build(reservation_params)
        @reservation.property = @property
        
        if @reservation.save
            BookingMailer.booking_confirmation(@reservation).deliver_now
            redirect_to reservation_path(@reservation), notice: "Reservation created successfully"
        else
            flash.now[:alert] = @reservation.errors.full_messages.join(", ")
            render :new, status: :unprocessable_entity
        end
    end
        
    def destroy
        @reservation = Reservation.find(params[:id])
        @reservation.destroy
        redirect_to reservations_path, alert: "Reservation cancelled"
    end
        private
    
    def set_property
        @property = Property.find(params[:property_id])
    end
    
    def reservation_params
        params.require(:reservation).permit(:checkin_date, :checkout_date, :guest_count, :phone_number)
    end
    
    def preview_params
        params.require(:reservation).permit(:checkin_date, :checkout_date, :guest_count, :phone_number)
    end
end