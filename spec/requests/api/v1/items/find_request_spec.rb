require 'rails_helper'
# rspec spec/requests/api/v1/items/find_request_spec.rb
RSpec.describe "Items API" do
  context 'Find One Item by Name Fragment' do
    it 'happy path, fetch one item by fragment' do
      merchant1 = create(:merchant)
      item1 = create :item, { name: "Best name", merchant_id: merchant1.id }
      item2 = create :item, { name: "The BEST name", merchant_id: merchant1.id }
      item3 = create :item, { name: "The second-best name", merchant_id: merchant1.id }
      item4 = create :item, { name: "The bestest name", merchant_id: merchant1.id }
      item5 = create :item, { name: "The worst name", merchant_id: merchant1.id }
      search_name = "best"

      get "/api/v1/items/find?name=#{search_name}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(Item.search_by_name(search_name)).to eq(item3)
    end

    xit 'sad path, no fragment matched' do
      merchant1 = create(:merchant)
      item1 = create :item, { name: "Best name", merchant_id: merchant1.id }
      item2 = create :item, { name: "The BEST name", merchant_id: merchant1.id }
      item3 = create :item, { name: "The second-best name", merchant_id: merchant1.id }
      item4 = create :item, { name: "The bestest name", merchant_id: merchant1.id }
      search_name = "worst"

      get "/api/v1/items/find?name=#{search_name}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(Item.search_by_name(search_name)).to eq([])
      expect(Item.search_by_name(search_name).count).to eq(0)
    end
  end
end
