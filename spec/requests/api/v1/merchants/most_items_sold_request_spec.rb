require 'rails_helper'
# rspec spec/requests/api/v1/merchants/most_items_sold_request_spec.rb
RSpec.describe "Merchants API" do
  context 'Get Merchants who Sold Most Items' do
    it 'happy path, fetch top 8 merchants by items sold' do
      get "/api/v1/merchants/most_items?quantity=#{quantity_params}"

    end
    it 'happy path, all 100 merchants if quantity is too big' do
    end
    it 'happy path, top one merchant by items sold' do
    end
    it 'sad path, returns an error of some sort if quantity is a string' do
    end
    it 'sad path, returns an error of some sort if quantity value is blank' do
    end
    it 'edge case sad path, quantity param is missing | AssertionError: expected 200 to equal 400' do
    end
  end

end
