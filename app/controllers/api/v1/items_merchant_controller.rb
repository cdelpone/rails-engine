class Api::V1::ItemsMerchantController < ApplicationController

  def show
    merchant = Item.find(params[:id]).merchant
    render json: MerchantSerializer.new(merchant)
  end
end
