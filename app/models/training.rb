class Training < ApplicationRecord
  belongs_to :user
  belongs_to :chat

  validates :duration, :type, :intensity, :team_size, presence: true
  validates :intensity, numericality: { in: (0..10) }
  validates :feedback_rating, numericality: { in: (0..10) }
end
