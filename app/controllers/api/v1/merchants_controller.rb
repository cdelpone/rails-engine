class Api::V1::MerchantsController < ApplicationController

  def index
    paginated = Merchant.all.offset(current_page*per_page).limit(per_page)
    render json: MerchantSerializer.new(paginated)
  end

  def show
    merchant = Merchant.find(params[:id])
    if merchant.present?
      render json: MerchantSerializer.new(merchant)
    else
      respond_with_errors(object)
      flash[:error]
    end
  end

private

  def current_page
    if params[:page].to_i <= 1
      params[:page] = 0
    else
      params[:page].to_i - 1
    end
  end

  def per_page
    (params[:per_page] || 20).to_i
  end
end
