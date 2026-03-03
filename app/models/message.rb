class Message < ApplicationRecord
  belongs_to :chat

  validates :role, :content, presence: true
end
