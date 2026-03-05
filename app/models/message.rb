class Message < ApplicationRecord
  belongs_to :chat

  validates :role, :content, presence: true

  def is_training?
    content.to_s.include?("# Training Session Plan")
  end
end
