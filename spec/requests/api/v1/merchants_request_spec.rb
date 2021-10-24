require 'rails_helper'
# rspec spec/requests/api/v1/merchants_request_spec.rb
describe "Merchants API" do
  it "gets all merchants" do
   create_list(:merchant, 20)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants[:data].count).to eq(20)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_an(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end

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

  it 'fetch first page of 50 merchants' do
    # require "pry"; binding.pry
  end
end

    # it "can get one book by its id" do
    #   id = create(:book).id
    #   get "/api/v1/books/#{id}"
    #   book = JSON.parse(response.body, symbolize_names: true)
    #   expect(response).to be_successful
    #   expect(book).to have_key(:id)
    #   expect(book[:id]).to eq(id)
    #   expect(book).to have_key(:title)
    #   expect(book[:title]).to be_a(String)
        # expect(merchant).to have_key(:id)
        # expect(merchant[:id]).to be_an(Integer)
        #
        # expect(merchant).to have_key(:name)
        # expect(merchant[:name]).to be_a(String)


    # end
