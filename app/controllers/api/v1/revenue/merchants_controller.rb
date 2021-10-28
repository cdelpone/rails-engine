class Api::V1::Revenue::MerchantsController < ApplicationController

  def index
    merchants = Merchant.most_revenue_by_merchant(params[:quantity])
    render json: MerchantNameRevenueSerializer.new(merchants)
  end

  def show
    merchant = Merchant.total_revenue(params[:id])
    render json: MerchantRevenueSerializer.new(merchant)
  end
end
