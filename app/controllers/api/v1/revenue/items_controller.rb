class Api::V1::Revenue::ItemsController < ApplicationController
 before_action :default_params, :invalid_params

  def index
    if params[:quantity].present?
      items = Item.most_revenue_by_item(params[:quantity])
      render json: ItemRevenueSerializer.new(items)
    else
      render json: { error: 'Bad Request' }, status: 400
    end
  end

private
  def invalid_params
    params[:quantity] == '' || !(params[:quantity] !~ /\D/)
  end

  def default_params
    params[:quantity] ||= 10
  end
end

  # private
  # def invalid_params
  #   params[:quantity] == '' || !(params[:quantity] !~ /\D/)
  # end
  #
  #   def default_params
  #     if params[:quantity]
  #       render json: { error: 'Bad Request' }, status: :bad_request
  #     else
  #       params[:quantity] ||= 10
  #     end
  #   end
  # raise ActionController::BadRequest unless params[:quantity]
