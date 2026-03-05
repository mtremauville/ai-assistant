class User < ApplicationRecord
  has_many :trainings, dependent: :destroy
  has_many :chats, dependent: :destroy

  validates :email, :password, :padel_level, :age, presence: true
  validates :hand_position, inclusion: { in: ["Left", "Right", "Both"] }
  validates :gender, inclusion: { in: ["male", "female", "other"] }, allow_nil: true
  validates :padel_level, numericality: { less_than_or_equal_to: 7.0 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
