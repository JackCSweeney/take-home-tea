class Tea < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :temperature, presence: true, numericality: true
  validates :brew_time, presence: true, numericality: true

  has_many :subscriptions, dependent: :destroy
  has_many :customers, through: :subscriptions
end