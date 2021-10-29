class Api::V1::Revenue::ItemsController < ApplicationController
  before_action :default_params
  before_action :invalid_params

  def index
    if params[:quantity].present?
      items = Item.most_revenue_by_item(params[:quantity])
      render json: ItemRevenueSerializer.new(items)
    else
      render json: { error: 'Bad Request' }, status: :bad_request
    end
  end

  private
  def default_params
    params[:quantity] ||= 10
  end

  def invalid_params
    if params[:quantity] == ""
      render json: { error: 'Bad Request' }, status: 400
    else
      items = Item.most_revenue_by_item(params[:quantity])
      render json: ItemRevenueSerializer.new(items)
    end
  end
end
