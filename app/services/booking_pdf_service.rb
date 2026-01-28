require 'prawn'
require 'prawn/table'

class BookingPdfService
  def initialize(reservation)
    @reservation = reservation
    @property = reservation.property
    @user = reservation.user
  end

  def generate_pdf
    pdf = Prawn::Document.new(page_size: 'A4', margin: [50, 50, 50, 50])
    
    # Header
    pdf.text "Booking Confirmation", size: 24, style: :bold, align: :center
    pdf.move_down 10
    pdf.text "Reservation ID: ##{@reservation.id}", size: 12, align: :center
    pdf.move_down 20
    
    # Property Information Section
    pdf.text "Property Details", size: 16, style: :bold
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    
    pdf.text "<b>Property Name:</b> #{@property.name}", inline_format: true
    pdf.text "<b>Host:</b> #{@property.host_name}", inline_format: true
    pdf.move_down 5
    
    pdf.text "<b>Address:</b>", inline_format: true
    pdf.text "#{@property.address_1}"
    pdf.text "#{@property.address_2}" if @property.address_2.present?
    pdf.text "#{@property.city}, #{@property.state}, #{@property.country}"
    pdf.move_down 10
    
    if @property.description.present?
      pdf.text "<b>Description:</b>", inline_format: true
      pdf.text @property.description, size: 10
      pdf.move_down 10
    end
    
    # Booking Details Section
    pdf.text "Booking Details", size: 16, style: :bold
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    
    booking_data = [
      ["Check-in Date", @reservation.checkin_date.strftime("%B %d, %Y")],
      ["Check-out Date", @reservation.checkout_date.strftime("%B %d, %Y")],
      ["Number of Nights", "#{@reservation.number_of_nights} night#{@reservation.number_of_nights != 1 ? 's' : ''}"],
      ["Number of Guests", "#{@reservation.guest_count} guest#{@reservation.guest_count != 1 ? 's' : ''}"]
    ]
    
    pdf.table(booking_data, header: false, width: pdf.bounds.width) do
      columns(0).font_style = :bold
      columns(0).width = 150
      columns(1).width = pdf.bounds.width - 150
    end
    pdf.move_down 15
    
    # Guest Information Section
    pdf.text "Guest Information", size: 16, style: :bold
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    
    guest_data = [
      ["Email", @user.email],
      ["Phone Number", @reservation.phone_number]
    ]
    
    pdf.table(guest_data, header: false, width: pdf.bounds.width) do
      columns(0).font_style = :bold
      columns(0).width = 150
      columns(1).width = pdf.bounds.width - 150
    end
    pdf.move_down 15
    
    # Pricing Section
    pdf.text "Pricing Breakdown", size: 16, style: :bold
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    
    nights = @reservation.number_of_nights
    price_per_night = @property.price
    total_price = @reservation.total_price
    
    pricing_data = [
      ["Price per Night", humanized_money(price_per_night)],
      ["Number of Nights", nights.to_s],
      ["", ""],
      ["<b>Total Price</b>", "<b>#{humanized_money(total_price)}</b>"]
    ]
    
    pdf.table(pricing_data, header: false, width: pdf.bounds.width, cell_style: { inline_format: true }) do
      columns(0).font_style = :bold
      columns(0).width = 150
      columns(1).width = pdf.bounds.width - 150
      rows(3).font_style = :bold
      rows(3).size = 14
    end
    pdf.move_down 20
    
    # Footer
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    pdf.text "Thank you for choosing #{@property.name}!", size: 12, style: :bold, align: :center
    pdf.move_down 5
    pdf.text "We look forward to hosting you!", size: 10, align: :center
    pdf.move_down 10
    pdf.text "Best regards,", size: 10, align: :center
    pdf.text @property.host_name, size: 10, style: :bold, align: :center
    pdf.move_down 10
    pdf.text "Booking Date: #{@reservation.created_at.strftime("%B %d, %Y at %I:%M %p")}", size: 9, align: :center, color: "666666"
    
    pdf.render
  end
  
  private
  
  def humanized_money(money)
    return "$0.00" unless money
    "#{money.symbol}#{money.amount.to_f.round(2)}"
  end
end
