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

  # describe '#next_id' do
    # before :each do
    #   @merchant_a = create :merchant, { id: 20 }
    #   @item_a = create :item, { merchant_id: @merchant_a.id }
    #   @item_b = create :item, { merchant_id: @merchant_a.id }
    # end
    #
    # it 'has the next id' do
    #   expect(Item.next_id).to eq(Item.maximum(:id).next)
    # end
  # end
end
