class Api::V1::Merchants::MostItemsController < ApplicationController
  before_action :default_params

  def index
      merchants = Merchant.most_items_sold(params[:quantity])
      render json: ItemsSoldSerializer.new(merchants)
  end

  private

  def default_params
    params[:quantity] ||= 5
  end
end
