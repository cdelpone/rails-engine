class Api::V1::Revenue::ItemsController < ApplicationController
  before_action :default_params

  def index
    items = Item.ranked_by_revenue(params[:quantity])
    render json: ItemRevenueSerializer.new(items)
  end

  private

  def default_params
    params[:quantity] ||= 10
  end
end
