class Api::V1::Items::FindController < ApplicationController

  def index
    item = Item.search_by_name(params[:name])
    if item
      render json: ItemSerializer.new(item)
    else
      render json: { data: {
        message: 'No Items match your search',
        status: 400
        } }
    end
  end
end
