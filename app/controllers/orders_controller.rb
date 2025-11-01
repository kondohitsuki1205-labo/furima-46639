class OrdersController < ApplicationController
    before_action :authenticate_user!
  before_action :set_item
  before_action :redirect_if_seller_or_sold

  def new
    @order_address = OrderAddress.new
  end

  def create
    @order_address = OrderAddress.new(order_params)
    if @order_address.valid?
      pay_item
      @order_address.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def redirect_if_seller_or_sold
    redirect_to root_path if current_user.id == @item.user_id || @item.order.present?
  end

  def order_params
  params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :block, :building, :phone_number)
        .merge(user_id: current_user.id, item_id: @item.id, token: params[:token])
end

  def pay_item
  return if Rails.env.development?  # ← 開発では決済呼ばず先に進む

  Payjp.api_key = Rails.application.credentials.dig(:payjp, :secret_key)
  Payjp::Charge.create(
    amount:   @item.price,
    card:     order_params[:token],
    currency: 'jpy'
  )
end
end