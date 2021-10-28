require 'rails_helper'
# rspec spec/requests/api/v1/revenue/items_request_spec.rb
RSpec.describe "Items API" do
  context 'Get Items with Most Revenue' do
    let!(:merch1) { create :merchant }
    let!(:merch2) { create :merchant }
    let!(:merch3) { create :merchant }
    let!(:merch4) { create :merchant }
    let!(:merch5) { create :merchant }
    let!(:item1) { create :item, { merchant_id: merch1.id } }
    let!(:item2) { create :item, { merchant_id: merch2.id } }
    let!(:item3) { create :item, { merchant_id: merch2.id } }
    let!(:item4) { create :item, { merchant_id: merch3.id } }
    let!(:item5) { create :item, { merchant_id: merch3.id } }
    let!(:item6) { create :item, { merchant_id: merch3.id } }
    let!(:item7) { create :item, { merchant_id: merch4.id } }
    let!(:item8) { create :item, { merchant_id: merch4.id } }
    let!(:item9) { create :item, { merchant_id: merch4.id } }
    let!(:item10) { create :item, { merchant_id: merch4.id } }
    let!(:item11) { create :item, { merchant_id: merch5.id } }
    let!(:customer) { create :customer }
    let!(:invoice1) { create :invoice, { customer_id: customer.id, created_at: DateTime.new(2021, 7, 1) } }
    let!(:invoice2) { create :invoice, { customer_id: customer.id, created_at: DateTime.new(2021, 1, 1) } }
    let!(:transaction1) { create :transaction, { invoice_id: invoice1.id, result: "success" } }
    let!(:transaction3) { create :transaction, { invoice_id: invoice2.id, result: "success" } }
    let!(:inv_item1) do # 1, 50
      create :invoice_item, { invoice_id: invoice1.id, item_id: item1.id, unit_price: 50, quantity: 20 }
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
      create :invoice_item, { invoice_id: invoice1.id, item_id: item5.id, unit_price: 100, quantity: 1 }
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
    let!(:inv_item11) do # 6, 150 200
      create :invoice_item, { invoice_id: invoice1.id, item_id: item11.id, unit_price: 150, quantity: 1 }
    end
    it 'happy path, fetch top 10 items by revenue' do
      get '/api/v1/revenue/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].length).to eq(10)
      expect(items[:data][0]).to be_a Hash
      expect(items[:data][0]).to have_key :id
      expect(items[:data][0]).to have_key :type
      expect(items[:data][0][:type]).to eq("item_revenue")
      expect(items[:data][0]).to have_key :attributes
      expect(items[:data][0][:attributes]).to be_a Hash
      expect(items[:data][0][:attributes]).to have_key :name
      expect(items[:data][0][:attributes][:name]).to be_a String
      expect(items[:data][0][:attributes]).to have_key :revenue
      expect(items[:data][0][:attributes][:revenue]).to be_a Float
      expect(items[:data][0][:attributes][:revenue]).to eq(1000.0)
      expect(items[:data][9][:attributes][:revenue]).to eq(100.0)
    end
    it 'happy path, top one item by revenue' do
      get '/api/v1/revenue/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      top_revenue = items[:data][0][:attributes][:revenue]
      last_revenue = items[:data][9][:attributes][:revenue]
      expected = (top_revenue > last_revenue)

      expect(expected).to be(true)
    end
    it 'happy path, return all items if quantity is too big' do
    end
    it 'sad path, returns an error of some sort if quantity value is less than 0' do
    end
    it 'edge case sad path, returns an error of some sort if quantity value is blank | AssertionError: expected 500 to equal 400' do
    end
    it 'edge case sad path, returns an error of some sort if quantity is a string | AssertionError: expected 500 to equal 400' do
    end
  end
end
