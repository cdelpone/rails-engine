require 'rails_helper'
# rspec spec/requests/api/v1/revenue/items_request_spec.rb
RSpec.describe "Items API" do
  context 'Get Items with Most Revenue' do
    get '/api/v1/revenue/items'

    expect(response).to be_successful

    it 'happy path, fetch top 10 items by revenue' do
    end
    it 'happy path, top one item by revenue' do
    end
    it 'happy path, return all items if quantity is too big' do
    end
    it 'sad path, returns an error of some sort if quantity value is less than 0' do
    end
    it 'edge case sad path, returns an error of some sort if quantity value is blank | AssertionError: expected 500 to equal 400' do
    end
    it 'edge case sad path, returns an error of some sort if quantity is a string | AssertionError: expected 500 to equal 400' do
    end
  end
end
