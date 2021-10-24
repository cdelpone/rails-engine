require 'rails_helper'
# rspec spec/requests/api/v1/merchants_request_spec.rb
RSpec.describe "Merchants API" do
  it "gets all merchants" do
   create_list(:merchant, 20)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)

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

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id].to_i).to eq(id)
    expect(merchant[:data][:id]).to be_a(String)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_a(String)
    expect(merchant[:data][:type]).to eq("merchant")

    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_a(Hash)
  end

  it 'fetches first page' do
    create_list(:merchant, 100)

    get '/api/v1/merchants?page=1'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].length).to eq(20)
  end

  it 'returns empty array when page has no data' do
    create_list(:merchant, 20)

    get '/api/v1/merchants?page=5'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
# require "pry"; binding.pry
    expect(merchants[:data].count).to eq(0)
    expect(merchants[:data]).to eq([])
  end
end
