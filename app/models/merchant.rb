class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.search_by_name(merch_name)
    "find_all?name=#{merch_name}"
  end

  def self.most_revenue_by_merchant(quanity_params)
    joins(:transactions)
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .where("transactions.result = ?", "success")
    .where("invoices.status = ?", "shipped")
    .group("invoices.id")
    .limit("quanity_params")
    .order("revenue desc")
  end
end
