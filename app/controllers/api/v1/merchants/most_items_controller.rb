class Api::V1::Merchants::MostItemsController < ApplicationController

  def index
    if params[:quantity].present?
      merchants = Merchant.most_items_sold(params[:quantity] ||= 5)
      render json: ItemsSoldSerializer.new(merchants)
    else
      raise ActionController::BadRequest
    end
  end
end
