class Api::V1::MerchantsController < ApplicationController

  def index
    paginated = Merchant.all.offset(current_page*per_page).limit(per_page)
    render json: MerchantSerializer.new(paginated)
  end

  def show
    item = Item.find(params[:id])
    if item.present?
      merchant = Merchant.find(item.merchant_id)
      render json: MerchantSerializer.new(merchant)
    elsif
      merchant = Merchant.find(params[:id])
      merchant.present?
      render json: MerchantSerializer.new(merchant)
    else
      respond_with_errors(object)
      flash[:error]
    end
  end

private

  def merchant_params
    params.require(:merchant).permit(:name)
  end

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
