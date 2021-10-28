class Item < ApplicationRecord
  validates_presence_of :name

  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  scope :search_by_name, ->(name) { where("name ilike ?", "%#{name}%").order(name: :desc).first }
end
