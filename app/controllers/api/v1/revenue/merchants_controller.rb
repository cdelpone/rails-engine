class Api::V1::Revenue::MerchantsController < ApplicationController

  def index
    merchants = Merchant.most_revenue_by_merchant(params[:quantity])
    render json: MerchantNameRevenueSerializer.new(merchants)
    raise ActionController::BadRequest unless params[:quantity]
  end

  def show
    if Merchant.find_by(id: params[:id])
      merchant = Merchant.total_revenue(params[:id])
      render json: MerchantRevenueSerializer.new(merchant)
    else
      render json: { error: 'Bad Request' }, status: :not_found
    end
  end
end
