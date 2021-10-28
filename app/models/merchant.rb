class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  scope :search_by_name, ->(name) { where("name ilike ?", "%#{name}%").order(name: :desc) }

  def self.most_revenue_by_merchant(quantity_params)
    joins(invoices: :transactions)
    .where("result = ?", "success")
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:id)
    .order("revenue DESC")
    .limit(quantity_params)
  end

  def self.total_revenue(merchant)
    joins(invoices: :transactions)
    .where("result = ?", "success")
    .where(id: merchant)
    .select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .group(:id)
    .first
  end

  def self.most_items_sold(quantity_params)
    joins(invoices: :transactions)
    .where("result = ?", "success")
    .select("merchants.*, SUM(invoice_items.quantity) AS count")
    .group(:id)
    .order("count DESC")
    .limit(quantity_params)
  end
end
