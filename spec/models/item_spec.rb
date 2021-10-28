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
    context 'Find One Item by Name Fragment' do
      it 'happy path, fetch one item by fragment' do
        merchant1 = create(:merchant)
        item1 = create :item, { name: "Best name", merchant_id: merchant1.id }
        item2 = create :item, { name: "The BEST name", merchant_id: merchant1.id }
        item3 = create :item, { name: "The second-best name", merchant_id: merchant1.id }
        item4 = create :item, { name: "The bestest name", merchant_id: merchant1.id }
        item5 = create :item, { name: "The worst name", merchant_id: merchant1.id }
        search_name = "best"

        expect(Item.search_by_name(search_name)).to eq(item1)
      end

      it 'sad path, no fragment matched' do
        merchant1 = create(:merchant)
        item1 = create :item, { name: "Best name", merchant_id: merchant1.id }
        item2 = create :item, { name: "The BEST name", merchant_id: merchant1.id }
        item3 = create :item, { name: "The second-best name", merchant_id: merchant1.id }
        item4 = create :item, { name: "The bestest name", merchant_id: merchant1.id }
        search_name = "worst"

        expect(Item.search_by_name(search_name)).to eq(nil)
      end
    end

    context 'Get Items with Most Revenue' do
      let!(:merch1) { create :merchant }
      let!(:merch2) { create :merchant }
      let!(:merch3) { create :merchant }
      let!(:merch4) { create :merchant }
      let!(:merch5) { create :merchant }
      let!(:merch6) { create :merchant }
      let!(:item1) { create :item, { merchant_id: merch1.id } }
      let!(:item2) { create :item, { merchant_id: merch2.id } }
      let!(:item3) { create :item, { merchant_id: merch2.id } }
      let!(:item4) { create :item, { merchant_id: merch3.id } }
      let!(:item5) { create :item, { merchant_id: merch3.id } }
      let!(:item6) { create :item, { merchant_id: merch4.id } }
      let!(:item7) { create :item, { merchant_id: merch4.id } }
      let!(:item8) { create :item, { merchant_id: merch5.id } }
      let!(:item9) { create :item, { merchant_id: merch5.id } }
      let!(:item10) { create :item, { merchant_id: merch6.id } }
      let!(:customer) { create :customer }
      let!(:invoice1) { create :invoice, { customer_id: customer.id, created_at: DateTime.new(2021, 7, 1) } }
      let!(:invoice2) { create :invoice, { customer_id: customer.id, created_at: DateTime.new(2021, 1, 1) } }
      let!(:invoice3) { create :invoice, { customer_id: customer.id, created_at: DateTime.new(2030, 1, 1) } }
      let!(:transaction1) { create :transaction, { invoice_id: invoice1.id, result: "success" } }
      let!(:transaction2) { create :transaction, { invoice_id: invoice2.id, result: "failed" } }
      let!(:transaction3) { create :transaction, { invoice_id: invoice2.id, result: "success" } }
      let!(:transaction4) { create :transaction, { invoice_id: invoice3.id, result: "failed" } }
      let!(:inv_item1) do # 1, 50
        create :invoice_item, { invoice_id: invoice1.id, item_id: item1.id, unit_price: 50, quantity: 1 }
      end

      let!(:inv_item2) do # 2, 300 600
        create :invoice_item, { invoice_id: invoice2.id, item_id: item2.id, unit_price: 100, quantity: 1 }
      end
      let!(:inv_item3) do
        create :invoice_item, { invoice_id: invoice2.id, item_id: item3.id, unit_price: 200, quantity: 1 }
      end

      let!(:inv_item4) do # 3, 100 150
        create :invoice_item, { invoice_id: invoice2.id, item_id: item4.id, unit_price: 100, quantity: 1 }
      end
      let!(:inv_item5) do
        create :invoice_item, { invoice_id: invoice3.id, item_id: item5.id, unit_price: 100, quantity: 1 }
      end

      let!(:inv_item6) do # 4, 600 # 1200
        create :invoice_item, { invoice_id: invoice2.id, item_id: item6.id, unit_price: 300, quantity: 1 }
      end
      let!(:inv_item7) do
        create :invoice_item, { invoice_id: invoice1.id, item_id: item7.id, unit_price: 300, quantity: 1 }
      end

      let!(:inv_item8) do # 5, 500 700
        create :invoice_item, { invoice_id: invoice2.id, item_id: item8.id, unit_price: 200, quantity: 1 }
      end
      let!(:inv_item9) do
        create :invoice_item, { invoice_id: invoice1.id, item_id: item9.id, unit_price: 300, quantity: 1 }
      end

      let!(:inv_item10) do # 6, 150 200
        create :invoice_item, { invoice_id: invoice1.id, item_id: item10.id, unit_price: 150, quantity: 1 }
      end

      it 'happy path, fetch top 5 items by revenue' do
        result = [item7, item9, item6, item3, item8]
        expect(Item.most_revenue_by_item(5)).to eq(result)
      end

      it 'happy path, top one item by revenue' do
        expect(Item.most_revenue_by_item(1)).to eq([item6])
      end
    end
  end
end
