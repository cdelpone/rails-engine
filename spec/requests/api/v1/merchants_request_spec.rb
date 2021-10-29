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

    it "sad path, bad integer id returns 404" do
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

    it "sad path, bad integer id returns 404" do
      id = create(:merchant).id

      get "/api/v1/merchants/157/items"

      expect(response.code).to eq("404")
      expect(response).not_to be_successful
    end
  end
end
