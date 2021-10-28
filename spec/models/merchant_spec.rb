require 'rails_helper'
# rspec spec/models/merchant_spec.rb
RSpec.describe Merchant, type: :model do
  describe 'relationships/validations' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }

    it { should validate_presence_of :name }
  end

  describe 'class methods/scopes' do
    describe 'search_by_name' do
      it 'does method' do
      end
    end
    describe 'most_revenue_by_merchant' do
      it 'does method' do
      end
    end
    describe 'total_revenue' do
      it 'does method' do
      end
    end
    describe 'most_items_sold' do
      it 'does method' do
      end
    end
  end
end
