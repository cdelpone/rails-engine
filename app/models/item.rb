class Item < ApplicationRecord
  validates_presence_of :name

  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  def self.search_by_name(item_name)
    "find?name=#{item_name}"
  end

end
