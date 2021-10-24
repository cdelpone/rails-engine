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
    describe '#first_20' do
      before :each do
      end

      it 'fetch first page of 20 merchants' do
      end
    end
  end
end
