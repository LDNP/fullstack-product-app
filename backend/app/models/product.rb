class Product < ApplicationRecord
  #validation rules
  validates :name, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}

  # set default availability to true if not provided
  after_initialize :set_default_availability

  private

  def set_default_availability
    self.available = true if available.nil?
  end
end
