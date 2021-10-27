class Api::V1::SearchController < ApplicationController
  def search_merchant
    @merchant = Merchant.search_by_name(params[:query]).limit(1)
    render json: @merchant
  end

  def search_items
    @items = Item.search_by_name(params[:query])
    render json: @items
  end
end
