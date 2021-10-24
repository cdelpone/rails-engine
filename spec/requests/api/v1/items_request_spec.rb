require 'rails_helper'
# rspec spec/requests/api/v1/items_request_spec.rb
RSpec.describe "Items API" do
  it "happy path, fetch all items if per page is really big" do
   create_list(:item, 20)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(20)

    items[:data].each do |item|
      expect(item.length).to eq(3)
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)
      expect(item).to have_key(:type)
      expect(item[:type]).to be_an(String)
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
    end

    expect(items[:data].count).to eq(20)

    expect(items).to be_a Hash
    expect(items[:data]).to be_an Array
    expect(items[:data][0]).to have_key :id
    expect(items[:data][0]).to have_key :type
    expect(items[:data][0][:type]).to eq("item")
    expect(items[:data][0]).to have_key :attributes
    expect(items[:data][0][:attributes]).to have_key :name
    expect(items[:data][0][:attributes][:name]).to be_a String
    expect(items[:data][0][:attributes]).to_not have_key :created_at
    expect(items[:data][0][:attributes]).to_not have_key :updated_at
  end
  # 
  # it 'happy path, fetch first page of 50 merchants' do
  #   create_list(:merchant, 50)
  #
  #   get '/api/v1/merchants?page=1'
  #
  #   expect(response).to be_successful
  #
  #   merchants = JSON.parse(response.body, symbolize_names: true)
  #
  #   expect(merchants[:data].length).to eq(20)
  # end
  #
  # it 'returns empty array when page has no data' do
  #   get '/api/v1/merchants?page=10'
  #
  #   expect(response).to be_successful
  #
  #   merchants = JSON.parse(response.body, symbolize_names: true)
  #
  #   expect(merchants[:data].count).to eq(0)
  #   expect(merchants[:data]).to eq([])
  # end
  #
  # it "happy path, fetch one merchant by id" do
  #   id = create(:merchant).id
  #
  #   get "/api/v1/merchants/#{id}"
  #
  #   expect(response).to be_successful
  #
  #   merchant = JSON.parse(response.body, symbolize_names: true)
  #
  #   expect(merchant[:data]).to have_key(:id)
  #   expect(merchant[:data][:id].to_i).to eq(id)
  #   expect(merchant[:data][:id]).to be_a(String)
  #
  #   expect(merchant[:data]).to have_key(:type)
  #   expect(merchant[:data][:type]).to be_a(String)
  #   expect(merchant[:data][:type]).to eq("merchant")
  #
  #   expect(merchant[:data]).to have_key(:attributes)
  #   expect(merchant[:data][:attributes]).to be_a(Hash)
  # end
  #
  # it "sad path, bad integer id returns 404" do
  #   id = create(:merchant).id
  #
  #   expect(response).to be_successful
  #
  #   get "/api/v1/merchants/19"
  #
  #   merchant = JSON.parse(response.body, symbolize_names: true)
  #
  #   expect(merchant[:data]).to have_key(:id)
  #   expect(merchant[:data][:id].to_i).to eq(id)
  #   expect(merchant[:data][:id]).to be_a(String)
  #
  #   expect(merchant[:data]).to have_key(:type)
  #   expect(merchant[:data][:type]).to be_a(String)
  #   expect(merchant[:data][:type]).to eq("merchant")
  #
  #   expect(merchant[:data]).to have_key(:attributes)
  #   expect(merchant[:data][:attributes]).to be_a(Hash)
  # end
  #
  # it "happy path, fetch all items from one merchant by its id " do
  #   merchant1 = create(:merchant)
  #
  #   item1 = create :item, { merchant_id: merchant1.id }
  #   item2 = create :item, { merchant_id: merchant1.id }
  #   item3 = create :item, { merchant_id: merchant1.id }
  #
  #   get "/api/v1/merchants/#{merchant1.id}/items"
  #
  #   expect(response).to be_successful
  #   # item = JSON.parse(response.body, symbolize_names: true)
  #   merchant1 = JSON.parse(response.body, symbolize_names: true)
  #
  #   expect(merchant1[:data]).to have_key(:id)
  # end


end
