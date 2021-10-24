class Api::V1::MerchantsController < ApplicationController
  def index
    paginated = Merchant.all.offset(current_page).limit(per_page)
   render json: MerchantSerializer.new(paginated)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end


private

  def current_page
    (params[:page] || 0).to_i
  end

  def per_page
    require "pry"; binding.pry
    # if params.present?
    (params[:per_page] || 20).to_i
  end
end
