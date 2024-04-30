class Subscription < ApplicationRecord
  validates :title, presence: true
  validates :price, presence: true, numericality: true
  validates :frequency, presence: true, numericality: true
  validates :status, presence: true
  enum status: ["cancelled", "active"]

  belongs_to :tea
  belongs_to :customer
end