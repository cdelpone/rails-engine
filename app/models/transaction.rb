class Transaction < ApplicationRecord
  belongs_to :invoice

  enum result: %w[success failed]

  scope :successful, lambda {
    where(result: 0)
  }
end
