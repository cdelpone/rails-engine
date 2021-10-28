class Api::V1::MerchantsController < ApplicationController

  def index
    paginated = Merchant.all.offset(current_page*per_page).limit(per_page)
    render json: MerchantSerializer.new(paginated)
  end

  def show
    if Item.all.blank?
      merchant = Merchant.find(params[:id])
      merchant.present?
      render json: MerchantSerializer.new(merchant)
    elsif
      item = Item.find(params[:id])
      if item.present?
        merchant = Merchant.find(item.merchant_id)
        render json: MerchantSerializer.new(merchant)
      end
    else
      respond_with_errors(merchant)
      flash[:error]
    end
  end

  def most_items

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
