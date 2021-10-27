class Item < ApplicationRecord
  validates_presence_of :name

  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name,
    using: {
      tsearch: {
        any_word: true,
        prefix: true
      }
    }
end
