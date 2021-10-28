require 'rails_helper'
# rspec spec/requests/api/v1/merchants/find_all_request_spec.rb
RSpec.describe "Merchants API" do
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

      expect(merchants[:data][0]).to be_a Hash
      expect(merchants[:data][0][:type]).to eq("merchant")
      expect(merchants[:data][0][:attributes]).to be_a Hash
      expect(merchants[:data][0][:attributes][:name]).to eq(merchant1.name)
      expect(merchants[:data][3][:attributes][:name]).to eq(merchant3.name)
    end

    it 'sad path, no fragment matched' do
      merchant1 = create :merchant, { name: "Best name" }
      merchant2 = create :merchant, { name: "The BEST name" }
      merchant3 = create :merchant, { name: "The second-best name" }
      search_name = "worst"

      get "/api/v1/merchants/find_all?name=#{search_name}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data]).to eq([])
    end
  end
end
