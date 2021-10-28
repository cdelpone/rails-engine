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
    else params[:search].present?
      search_items = Item.search_by_name[:search]
      render json: ItemSerializer.new(search_items)
    end
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: 201
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  def update
    item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(item)
  end

private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
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
