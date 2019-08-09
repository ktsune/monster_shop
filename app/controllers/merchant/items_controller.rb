class Merchant::ItemsController < Merchant::BaseController
  before_action :set_item, only: [:destroy, :edit, :update, :fulfill, :activate, :deactivate]
  before_action :set_merchant, only: [:create, :index]

  def fulfill
    order_item = @item.get_order_item(params[:order_id])
    order_item.update(status: 'fulfilled')
    amt = @item.inventory - order_item.quantity
    @item.update(inventory: amt)
    flash[:success] = "#{@item.name} has been fulfilled."
    order = Order.find(params[:order_id])
    order.fulfilled?
    redirect_to merchant_order_path(order)
  end

  def index
    @items = @merchant.items
  end

  def new
    @item = Item.new(params[:merchant_id])
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to dashboard_items_path
    else
      generate_flash(@item)
      render :edit
    end
  end

  def create
    @item = @merchant.items.new(item_params)
    if @item.save
      redirect_to dashboard_items_path
    else
      generate_flash(@item)
      render :new
    end
  end

  def destroy
    if @item.orders.empty?
      @item.destroy
    else
      flash[:alert] = "#{@item.name} can not be deleted - it has been ordered!"
    end
    redirect_to dashboard_items_path
  end

  def deactivate
    @item.update(active: false)
    flash[:notice] = "#{@item.name} is no longer available for sale."
    redirect_to dashboard_items_path
  end

  def activate
    @item.update(active: true)
    flash[:notice] = "#{@item.name} is now available for sale."
    redirect_to dashboard_items_path
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :image, :inventory)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_merchant
    @merchant = Merchant.find(current_user.merchant_id)
  end
end
