class ApplicationController < ActionController::API

  # private
  #
  # def current_merchant
  #   @merchant = Merchant.find(params[:merchant_id])
  # end

  def respond_with_errors(object)
    render json: {errors: ErrorSerializer.serialize(object)}, status: :unprocessable_entity
  end
end
