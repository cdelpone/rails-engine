class Api::V1::Revenue::ItemsController < ApplicationController

  def index
    if params[:quantity].present?
      items = Item.ranked_by_revenue(params[:quantity])
      render json: ItemRevenueSerializer.new(items)
    else params[:quantity] = 10
      items = Item.ranked_by_revenue(params[:quantity])
      render json: ItemRevenueSerializer.new(items)
    end
  end
end
