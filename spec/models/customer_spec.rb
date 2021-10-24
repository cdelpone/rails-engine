require 'rails_helper'
# rspec spec/models/customer_spec.rb
RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items)}
  end

  # describe 'class methods/scopes' do
  #   it 'has all customer full names' do
  #     expected = [cust1, cust2, cust3, cust4].map do |cust|
  #       "#{cust.first_name} #{cust.last_name}"
  #     end
  #     result = Customer.full_names.map(&:customer_name)
  #
  #     expect(result).to eq(expected)
  #   end
  # end

  # describe 'instance methods' do
  #   it 'has a full name' do
  #     expect(cust1.full_name).to eq("#{cust1.first_name} #{cust1.last_name}")
  #   end
  # end
end
