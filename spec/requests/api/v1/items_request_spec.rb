require 'rails_helper'
# rspec spec/requests/api/v1/items_request_spec.rb
RSpec.describe "Items API" do
  context 'Get All Items' do
    it "happy path, fetch all items(even if per page is really big)" do
     create_list(:item, 100)
      get '/api/v1/items?page=1&per_page=500000'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

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
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end

      expect(items[:data].count).to eq(100)
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

    it 'happy path, fetch first page of 50 items' do
      create_list(:item, 100)

      get '/api/v1/items?page=1&per_page=50'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].length).to eq(50)
    end

    it 'happy path, fetch a page of items which would contain no data' do
      get '/api/v1/items?page=10'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(0)
      expect(items[:data]).to eq([])
    end

    it 'happy path, fetching page 1 is the same list of first 20 in db' do
      create_list(:item, 100)

      get '/api/v1/items?page=1'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].length).to eq(20)
      expected = Item.all[0..19].count
      expect(items[:data].count).to eq(expected)
      expected2 = Item.all[0..19]
      expect(items[:data][0][:attributes][:name]).to eq(expected2.first.name)
    end

    it 'sad path, fetching page 1 if page is 0 or lower' do
      create_list(:item, 100)

      get '/api/v1/items?page=0'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].length).to eq(20)
    end

    it 'happy path, fetch second page of 20 items' do
      create_list(:item, 100)

      get '/api/v1/items?page=2'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].length).to eq(20)
    end
  end

  context 'Get One Item' do
    it "happy path, fetch one item by id" do
      merchant1 = create(:merchant)
      item1 = create :item, { merchant_id: merchant1.id }
      item2 = create :item, { merchant_id: merchant1.id }
      item3 = create :item, { merchant_id: merchant1.id }

      get "/api/v1/items/#{item1.id}"

      expect(response).to be_successful

      item1 = JSON.parse(response.body, symbolize_names: true)

      expect(item1[:data]).to have_key(:id)
      expect(item2[:data]).to eq(nil)
      expect(item3[:data]).to eq(nil)
    end

    it "sad path, bad integer id returns 404" do
      merchant1 = create(:merchant)
      item1 = create :item, { merchant_id: merchant1.id }

      get "/api/v1/items/19"
      expect(response.code).to eq("404")
      expect(response).not_to be_successful
    end

    it "edge case, string id returns 404" do
      merchant1 = create(:merchant)
      item1 = create :item, { merchant_id: merchant1.id.to_s }

      get "/api/v1/items/sfdg"

      expect(response.code).to eq("404")
      expect(response).not_to be_successful
    end
  end

  context 'Create (then Delete) One Item' do
    it 'can create an item - response should be okay to process' do
      merchant1 = create(:merchant)
      item_params = ({
                      name: "Mr. Kenny Boehm",
                      description:  "Why are you the way that you are? Honestly, every time I try to do something fun, or exciting, you make it??? not that way. I hate??? so much about the things that you choose to be.",
                      unit_price: 556.0,
                      merchant_id: merchant1.id
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it 'can delete an item - response should be okay to process' do
      merchant1 = create(:merchant)
      item1 = create :item, { merchant_id: merchant1.id }

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item1.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item1.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'can delete an item - response should be okay to process' do
      merchant1 = create(:merchant)
      item1 = create :item, { merchant_id: merchant1.id }

      expect{ delete "/api/v1/items/#{item1.id}" }.to change(Item, :count).by(-1)
      expect(response).to be_successful
      expect{Item.find(item1.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'Update One Item' do
    it "happy path, fetch one item by id; can update an item" do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: "Mr. Kenny Boehm" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("Mr. Kenny Boehm")
    end

    # xit 'happy path, works with only partial data, too' do
    # end

    it "sad path, bad integer id returns 404" do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: "Mr. Kenny Boehm" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/19", headers: headers, params: JSON.generate({item: item_params})

      item = Item.find_by(id: id)

      expect(response.code).to eq("404")
      expect(response).not_to be_successful
    end

    it "edge case, string id returns 404" do
      id = create(:item).id.to_s
      previous_name = Item.last.name
      item_params = { name: "Mr. Kenny Boehm" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/asrfgdh", headers: headers, params: JSON.generate({item: item_params})

      item = Item.find_by(id: id)

      expect(response.code).to eq("404")
      expect(response).not_to be_successful
    end

    xit "edge case, bad merchant id returns 400 or 404" do
      merchant1_id = create(:merchant).id.to_s
      item1 = create :item, { merchant_id: merchant1_id }
      previous_name = Item.last.name
      item_params = { name: "Mr. Kenny Boehm" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item1.id}", headers: headers, params: JSON.generate({item: item_params})

      expect(response.code).to eq("404")
      expect(response).not_to be_successful
    end
  end

  context 'Get an Items Merchant' do
    # sad path, bad integer id returns 404
    # edge case, string id returns 404
    it "happy path, fetch one merchant by id (get an items merchant)" do
      merchant = create(:merchant)
      item = create :item, { merchant_id: merchant.id }
      merchant2 = create(:merchant)
      item2 = create :item, { merchant_id: merchant2.id }
      item3 = create :item, { merchant_id: merchant2.id }
      item4 = create :item, { merchant_id: merchant2.id }

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to eq(item.merchant_id.to_s)
      expect(merchant[:data][:id]).not_to eq(item2.merchant_id.to_s)
      expect(merchant[:data][:id]).not_to eq(item3.merchant_id.to_s)
      expect(merchant[:data][:id]).not_to eq(item4.merchant_id.to_s)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data][:type]).to eq("merchant")
      expect(merchant[:data][:attributes]).to be_a(Hash)
    end
  end
end
