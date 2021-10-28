class Api::V1::Revenue::MerchantsController < ApplicationController

    def index
      merchants = Merchant.most_revenue_by_merchant(params[:quantity])
      render json: MerchantSerializer.new(merchants)
    end
  end
