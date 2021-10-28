require 'rails_helper'
# rspec spec/models/item_spec.rb
RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }

    it { should validate_presence_of :name }
  end

  describe 'class methods/scopes' do
    describe 'search_by_name' do
      it 'does method' do
      end
    end
    describe 'most_revenue_by_item' do
      it 'does method' do
      end
    end
  end
end
