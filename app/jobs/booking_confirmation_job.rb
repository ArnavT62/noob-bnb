class BookingConfirmationJob < ApplicationJob
  queue_as :default

  def perform(reservation)
    BookingMailer.booking_confirmation(reservation).deliver_now
  rescue StandardError => e
    Rails.logger.error "Failed to send booking confirmation email: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    # Re-raise to let Solid Queue handle retries
    raise
  end
end
