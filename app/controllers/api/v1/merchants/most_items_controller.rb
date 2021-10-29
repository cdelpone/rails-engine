class Api::V1::Merchants::MostItemsController < ApplicationController
  # before_action :default_params

  def index
    if params[:quantity].present?
      merchants = Merchant.most_items_sold(params[:quantity] ||= 5)
      render json: ItemsSoldSerializer.new(merchants)
    else
      raise ActionController::BadRequest
    end
  end
  # 
  # private
  #
  # def default_params
  #   params[:quantity] ||= 5
  # end
end
