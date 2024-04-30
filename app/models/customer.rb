class Customer < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :address, presence: true

  has_many :subscriptions, dependent: :destroy
  has_many :teas, through: :subscriptions
end