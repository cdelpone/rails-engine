require 'rails_helper'
# rspec spec/requests/api/v1/merchants_request_spec.rb
RSpec.describe "Merchants API" do
  it "happy path, fetch all merchants if per page is really big" do
   create_list(:merchant, 20)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)

    merchants[:data].each do |merchant|
      expect(merchant.length).to eq(4)
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_an(String)
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(merchant).to have_key(:relationships)
      expect(merchant[:relationships]).to be_a(Hash)
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
    expect(merchants[:data][0]).to have_key :relationships
    expect(merchants[:data][0][:relationships]).to_not have_key :items
  end

  it 'happy path, fetch first page of 50 merchants' do
    create_list(:merchant, 50)

    get '/api/v1/merchants?page=1'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].length).to eq(20)
  end

  it 'returns empty array when page has no data' do
    get '/api/v1/merchants?page=10'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(0)
    expect(merchants[:data]).to eq([])
  end

  it "happy path, fetch one merchant by id" do
    id = create(:merchant).id

    item1 = create :item, { merchant_id: id }
    item2 = create :item, { merchant_id: id }
    item3 = create :item, { merchant_id: id }

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id].to_i).to eq(id)
    expect(merchant[:data][:id]).to be_a(String)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_a(String)
    expect(merchant[:data][:type]).to eq("merchant")

    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_a(Hash)

    expect(merchant[:data]).to have_key(:relationships)
    expect(merchant[:data][:relationships]).to be_a(Hash)

    expect(merchant[:data][:relationships]).to have_key :items
    expect(merchant[:data][:relationships][:items]).to have_key :data
  end

  xit "sad path, bad integer id returns 404" do
    id = create(:merchant).id

    get "/api/v1/merchants/19"

    expect(response.code).to eq("404")
    expect(response).not_to be_successful
  end

  it "happy path, fetch all items from one merchant by its id" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)

    item1 = create :item, { merchant_id: merchant1.id }
    item2 = create :item, { merchant_id: merchant1.id }
    item3 = create :item, { merchant_id: merchant1.id }

    item4 = create :item, { merchant_id: merchant2.id }
    item5 = create :item, { merchant_id: merchant2.id }

    get "/api/v1/merchants/#{merchant1.id}/items"

    expect(response).to be_successful

    merchant_items = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_items[:data][0]).to have_key(:id)
    expect(merchant_items[:data].count).to eq(3)
    expect(merchant_items[:data][0]).to have_key(:attributes)
    # merchant_items[:data].each do |merchant_items|
    #   expect(merchant.length).to eq(4)
    #   expect(merchant).to have_key(:id)
    #   expect(merchant[:id]).to be_an(String)
    #   expect(merchant).to have_key(:type)
    #   expect(merchant[:type]).to be_an(String)
    #   expect(merchant).to have_key(:attributes)
    #   expect(merchant[:attributes]).to be_a(Hash)
    #   expect(merchant[:attributes]).to have_key(:name)
    #   expect(merchant[:attributes][:name]).to be_a(String)
    #   expect(merchant).to have_key(:relationships)
    #   expect(merchant[:relationships]).to be_a(Hash)
    # end
  end
end
