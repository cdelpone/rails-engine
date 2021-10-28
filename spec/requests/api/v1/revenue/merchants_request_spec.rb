require 'rails_helper'
# rspec spec/requests/api/v1/revenue/merchants_request_spec.rb
RSpec.describe "Merchants API" do
  context 'Get Merchants with Most Revenue' do
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
    let!(:transaction1) { create :transaction, { invoice_id: invoice1.id, result: 0 } }
    let!(:transaction2) { create :transaction, { invoice_id: invoice2.id, result: 1 } }
    let!(:transaction3) { create :transaction, { invoice_id: invoice2.id, result: 0 } }
    let!(:transaction4) { create :transaction, { invoice_id: invoice3.id, result: 1 } }
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

    it 'happy path, fetch top 5 merchants by revenue' do
      quantity_params = 5
      get "/api/v1/revenue/merchants?quantity=#{quantity_params}"
      # get "/api/v1/revenue/merchants?quantity=10"
      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(Merchant.most_revenue_by_merchant(5)).to eq(5)
      # expect(Merchant.most_revenue_by_merchant(5).count).to eq(5)
    end

    xit 'happy path, top one merchant by revenue' do
    end

    xit 'happy path, all 100 merchants if quantity is too big' do
    end

    xit 'sad path, returns an error of some sort if quantity is a string' do
    end

    xit 'sad path, returns an error of some sort if quantity value is blank' do
    end

    xit 'edge case sad path, quantity param is missing | AssertionError: expected 200 to equal 400' do
    end
  end

  context 'Get Revenue of a Single Merchant' do
    it 'happy path, fetch revenue for merchant id' do
      id = create(:merchant).id
      get "/api/v1/revenue/merchants/#{id}"
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)
    end

    xit "sad path, bad integer id returns 404" do
      id = create(:merchant).id

      get "/api/v1/revenue/merchants/#{id}"

      expect(response.code).to eq("404")
      expect(response).not_to be_successful
    end
  end
end
