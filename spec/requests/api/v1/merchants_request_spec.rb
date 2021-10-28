require 'rails_helper'
# rspec spec/requests/api/v1/merchants_request_spec.rb
RSpec.describe "Merchants API" do
  context 'Get All Merchants' do
    # happy path, fetch monthly revenue
    it "happy path, fetch all merchants if per page is really big" do
     create_list(:merchant, 20)
      get '/api/v1/merchants?page=1&per_page=500000'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      merchants[:data].each do |merchant|
        expect(merchant.length).to eq(3)
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_an(String)
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
      expect(merchants[:data].count).to eq(20)
      expect(merchants).to be_a Hash
      expect(merchants[:data]).to be_an Array
      expect(merchants[:data][0]).to have_key :id
      expect(merchants[:data][0]).to have_key :type
      expect(merchants[:data][0][:type]).to eq("merchant")
      expect(merchants[:data][0]).to have_key :attributes
      expect(merchants[:data][0][:attributes]).to have_key :name
      expect(merchants[:data][0][:attributes][:name]).to be_a String
      expect(merchants[:data][0][:attributes]).to_not have_key :created_at
      expect(merchants[:data][0][:attributes]).to_not have_key :updated_at
    end

    it 'happy path, fetch first page of 50 merchants' do
      create_list(:merchant, 100)

      get '/api/v1/merchants?page=1&per_page=50'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].length).to eq(50)
    end

    it 'happy path, fetch a page of merchants which would contain no data' do
      get '/api/v1/merchants?page=10'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(0)
      expect(merchants[:data]).to eq([])
    end

    it 'happy path, fetching page 1 is the same list of first 20 in db' do
      create_list(:merchant, 100)

      get '/api/v1/merchants?page=1'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].length).to eq(20)
      expected = Merchant.all[0..19].count
      expect(merchants[:data].count).to eq(expected)
      expected2 = Merchant.all[0..19]
      expect(merchants[:data][0][:attributes][:name]).to eq(expected2.first.name)
    end

    it 'sad path, fetching page 1 if page is 0 or lower' do
      create_list(:merchant, 100)

      get '/api/v1/merchants?page=0'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].length).to eq(20)
    end

    it 'happy path, fetch second page of 20 items' do
      create_list(:merchant, 100)

      get '/api/v1/merchants?page=2'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].length).to eq(20)
    end
  end

  context 'Get One Merchant' do
    it "happy path, fetch one merchant by id" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      item1 = create :item, { merchant_id: merchant1.id }
      item2 = create :item, { merchant_id: merchant1.id }

      get "/api/v1/merchants/#{merchant1.id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id].to_i).to eq(merchant1.id)
      expect(merchant[:data][:id]).to be_a(String)

      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to eq("merchant")

      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to be_a(Hash)
      expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
      expect(merchant[:data][:attributes][:name]).not_to eq(merchant2.name)
    end

    xit "sad path, bad integer id returns 404" do
      id = create(:merchant).id

      get "/api/v1/merchants/19"

      expect(response.code).to eq("404")
      expect(response).not_to be_successful
    end
  end

  context 'Get A Merchants Items' do
    it "happy path, fetch all items from one merchant by its id" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      item1 = create :item, { merchant_id: merchant1.id }
      item2 = create :item, { merchant_id: merchant1.id }
      item3 = create :item, { merchant_id: merchant2.id }
      item4 = create :item, { merchant_id: merchant2.id }

      get "/api/v1/merchants/#{merchant1.id}/items"

      expect(response).to be_successful

      merchant_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_items[:data][0]).to have_key(:id)
      expect(merchant_items[:data].count).to eq(2)
      expect(merchant_items[:data][0]).to have_key(:attributes)
      expect(merchant_items[:data][0][:attributes]).to have_key(:name)
      expect(merchant_items[:data][0][:attributes]).to have_key(:description)
      expect(merchant_items[:data][0][:attributes]).to have_key(:unit_price)
      expect(merchant_items[:data][0][:attributes]).to have_key(:merchant_id)
      expect(merchant_items[:data][0][:type]).to eq("item")
      expect(merchant_items[:data][0][:attributes][:name]).to eq(item1.name)
      expect(merchant_items[:data][1][:attributes][:name]).to eq(item2.name)
      expect(merchant_items[:data][0][:attributes][:name]).not_to eq(item3.name)
      expect(merchant_items[:data][0][:attributes][:name]).not_to eq(item4.name)
    end

    xit "sad path, bad integer id returns 404" do
      id = create(:merchant).id

      get "/api/v1/merchants/157/items"

      expect(response.code).to eq("404")
      expect(response).not_to be_successful
    end
  end

  context 'Find All Merchants by Name Fragments' do
    it 'happy path, fetch all merchants matching a pattern' do
      merchant1 = create :merchant, { name: "Best name" }
      merchant2 = create :merchant, { name: "The BEST name" }
      merchant3 = create :merchant, { name: "The second-best name" }
      merchant4 = create :merchant, { name: "The bestest name" }
      merchant5 = create :merchant, { name: "The worst name" }
      search_name = "best"

      get "/api/v1/merchants/find_all?name=#{search_name}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(Merchant.search_by_name(search_name)).to eq([merchant3, merchant4, merchant2, merchant1])
      expect(Merchant.search_by_name(search_name).count).to eq(4)
    end

    it 'sad path, no fragment matched' do
      merchant1 = create :merchant, { name: "Best name" }
      merchant2 = create :merchant, { name: "The BEST name" }
      merchant3 = create :merchant, { name: "The second-best name" }
      search_name = "worst"

      get "/api/v1/merchants/find_all?name=#{search_name}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(Merchant.search_by_name(search_name)).to eq([])
      expect(Merchant.search_by_name(search_name).count).to eq(0)
    end
  end

  context 'Get Merchants with Most Revenue' do
    it 'happy path, fetch top 5 merchants by revenue' do
      create_list(:merchant, 50)
      create_list(:item, 50)
      create_list(:invoice, 50)
      create_list(:invoice_item, 50)
      create_list(:customer, 5)
      create_list(:transaction, 50)
      quantity_params = 5
      get "/api/v1/revenue/merchants?quantity=#{quantity_params}"
      # get "/api/v1/revenue/merchants?quantity=10"
      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)
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

  context 'Get Merchants who Sold Most Items' do
    # sad path, returns an error of some sort if quantity is a string
    # sad path, returns an error of some sort if quantity value is blank
    # happy path, all 100 merchants if quantity is too big
    # happy path, top one merchant by items sold
    # edge case sad path, quantity param is missing | AssertionError: expected 200 to equal 400
    it 'happy path, fetch top 8 merchants by items sold' do

    end
  end

  context 'Get Revenue of a Single Merchant' do
    # sad path, bad integer id returns 404 | AssertionError: expected { Object (id, _details, ...) } to have property 'code' of 404, but got 200
    it 'happy path, fetch revenue for merchant id' do

    end
  end
end
