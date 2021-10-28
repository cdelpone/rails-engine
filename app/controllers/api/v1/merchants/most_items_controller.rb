class Api::V1::Merchants::MostItemsController < ApplicationController

  def index
    if params[:quantity].present?
      merchants = Merchant.most_items_sold(params[:quantity])
      render json: ItemsSoldSerializer.new(merchants)
    else params[:quantity] = 5
      merchants = Merchant.most_items_sold(params[:quantity])
      render json: ItemsSoldSerializer.new(merchants)
    end
  end
end
