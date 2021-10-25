class Api::V1::ItemsController < ApplicationController

  def index
    if params[:merchant_id].present?
      merchant = Merchant.find(params[:merchant_id])
      items = merchant.items
    else
      items = Item.all.offset(current_page*per_page).limit(per_page)
    end
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    if item.present?
      render json: ItemSerializer.new(item)
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
