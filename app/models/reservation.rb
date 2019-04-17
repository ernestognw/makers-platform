class Reservation < ApplicationRecord
  enum status: [:confirmed, :complete, :cancelled, :blocked]
  enum purpose: [:academic, :entrepreneurship, :research, :personal]

  belongs_to :equipment
  belongs_to :user

  validates :status, :purpose, :start_time, :end_time, presence: true
  validate :date_range_valid, :not_overlapped, :date_is_available

  scope :upcoming, ->(limit) { where('start_time > ?', Time.now).order(:start_time).limit(limit) }

  def overlapped_reservations
    equipment.reservations
             .where.not(id: id)
             .where('start_time < ? AND ? < end_time', end_time, start_time)
             .where.not('status = ?', Reservation.statuses[:cancelled])
  end

  def not_overlapped
    if start_time.present? && end_time.present?
      if overlapped_reservations.exists?
        errors.add(:date, 'is overlapping with another reservation')
      end
    end
  end

  def get_first_available_overlap(st, et, day)
    equipment.available_hours
             .where(day_of_week: day)
             .where('start_time < ? AND ? < end_time', et.to_formatted_s(:time), st.to_formatted_s(:time))
             .where('start_time <= ?', st.to_formatted_s(:time))
             .order(start_time: :asc)
             .first
  end

  def date_is_available
    return unless start_time.present? && end_time.present?
    st = start_time
    day = start_time.wday
    et = end_time
    et = Time.new.end_of_day if bigger(st, end_time) # this means reservation is overnight
    look_for_available_overlaps(st, et, day)
  end

  def look_for_available_overlaps(st, et, day)
    begin
      first_match = get_first_available_overlap(st, et, day)
      if first_match.blank?
        errors.add(:date, 'is not within the equipment available hours')
        return
      else # change st to be the end of the first_match
        st = first_match.end_time
        day = (day + 1) % 7 if bigger(start_time, st) # check for next day, if overnight reservation
      end
      # continue if end_time > first_match.end_time
    end while bigger(end_time, st)
  end

  def remove_overlapped
    overlapped_reservations.each(&:cancelled!) # TODO: notify user of cancellation
  end

  def date_range_valid
    return if start_time.blank?

    errors.add(:start_time, "can't be in the past") if start_time < Time.now
    errors.add(:end_time, "can't be before start time") if end_time.present? && end_time < start_time
  end

  private

  def bigger(time_a, time_b)
    time_a.to_formatted_s(:time) > time_b.to_formatted_s(:time)
  end
end
