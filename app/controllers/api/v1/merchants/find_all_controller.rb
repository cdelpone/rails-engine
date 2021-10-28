class Api::V1::Merchants::FindAllController < ApplicationController

  def index
    merchants = Merchant.search_by_name(params[:name])
    if merchants
      render json: MerchantSerializer.new(merchants)
    else
      render json: { data: {
        message: 'No Merchants match your search',
        status: 400
        } }
    end
  end
end
