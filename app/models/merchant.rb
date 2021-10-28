class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  scope :search_by_name, ->(name) { where("name ilike ?", "%#{name}%").order(name: :desc) }

  def self.most_revenue_by_merchant(quantity_params)
    joins(invoices: :transactions)
    .where("transactions.result = ?", "success")
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .where("invoices.status = ?", "shipped")
    .group("id")
    .order("revenue desc")
    .limit(quantity_params)
  end
end
