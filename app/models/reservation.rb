class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :property
  validates :checkin_date, presence: true
  validates :checkout_date, presence: true
  validates :guest_count, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :guest_count_within_limit
  validates :phone_number, presence: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }
  validate :checkin_date_before_checkout_date
  validate :checkin_date_not_in_past
  validate :no_overlapping_reservations
  def guest_count_within_limit
    if guest_count && property && guest_count > property.guest_count
      errors.add(:guest_count, "cannot exceed maximum of #{property.guest_count} guests")
    end
  end

  def checkin_date_not_in_past
    if checkin_date && checkin_date < Date.today
      errors.add(:checkin_date, "cannot be in the past")
    end
  end

  def checkin_date_before_checkout_date
    if checkin_date && checkout_date && checkin_date >= checkout_date
      errors.add(:checkin_date, "must be before checkout date")
    end
  end
  def number_of_nights
   if checkin_date && checkout_date && checkin_date < checkout_date
    (checkout_date - checkin_date).to_i
  else
    0
    end
  end
  
  def total_price
    if property && checkin_date && checkout_date && checkin_date < checkout_date
      property.price * number_of_nights
    else
      Money.new(0, property&.price_currency || "USD")
    end
  end
  def no_overlapping_reservations
    overlapping = property.reservations
      .where.not(id: id)
      .where("checkin_date < ? AND checkout_date > ?", checkout_date, checkin_date)
      .exists?
    
    errors.add(:base, "The property is already reserved for the selected dates") if overlapping
  end
  scope :upcoming_reservations, -> { where('checkin_date >= ?', Date.today).order(:checkin_date) }
  scope :current_reservations, -> {where('checkout_date > ?', Date.today ).where("checkin_date < ?", Date.today).order(:checkout_date)}
end
