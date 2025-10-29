class ItemsController < ApplicationController
   before_action :authenticate_user!, except: [:index, :show]

  def index
    @items = Item.order(created_at: :desc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.build(item_params)
    if @item.save
      redirect_to @item
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to root_path
  end
  
  private
  def item_params
    params.require(:item).permit(:name, :description, :price, :image,
                               :category_id, :status_id, :shipping_fee_id,
                               :prefecture_id, :scheduled_delivery_id).merge(user_id: current_user.id)
  end
end