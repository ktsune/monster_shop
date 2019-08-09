class Admin::MerchantsController < Admin::BaseController
  before_action :set_merchant, only: [:show, :destroy, :enable, :disable, :edit, :update]

  def index
    @merchants = Merchant.all
  end

  def show
    @orders = @merchant.pending_orders
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      redirect_to '/merchants'
    else
      generate_flash(@merchant)
      render :new
    end
  end

  def edit
  end

  def update
    if @merchant.update_attributes(merchant_params)
      redirect_to "/merchants/#{@merchant.id}"
    else
      generate_flash(@merchant)
      render :edit
    end
  end

  def destroy
    if @merchant.order_items.empty?
      @merchant.destroy
    else
      flash[:alert] = "#{@merchant.name} can not be deleted - they have orders!"
    end
    redirect_to '/merchants'
  end

  def enable
    @merchant.items_active
    @merchant.update(enabled: true)
    flash[:success] = "The account for #{@merchant.name} is now enabled."
    redirect_to admin_merchants_path
  end

  def disable
    @merchant.items_inactive
    @merchant.update(enabled: false)
    flash[:success] = "The account for #{@merchant.name} is now disabled."
    redirect_to admin_merchants_path
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name, :address, :city, :state, :zip)
  end

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end
