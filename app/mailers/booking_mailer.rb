class BookingMailer < ApplicationMailer
  def booking_confirmation(reservation)
    @reservation = reservation
    @property = reservation.property
    @user = reservation.user
    
    # Generate PDF
    pdf_service = BookingPdfService.new(reservation)
    pdf_content = pdf_service.generate_pdf
    
    # Attach PDF
    attachments["booking_confirmation_#{reservation.id}.pdf"] = pdf_content
    
    mail(
      to: @user.email,
      subject: "Booking Confirmation - #{@property.name}"
    )
  end
end
