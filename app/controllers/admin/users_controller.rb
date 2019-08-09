class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:enable, :disable]

  def index
    @users = User.where.not(role: "admin")
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    @merchants = Merchant.all
  end

  def update
    @user = User.find(params[:id])
    unless user_params[:merchant_id].scan(/\D/).empty?
      params[:user][:merchant_id] = Merchant.find_by(name: params[:user][:merchant_id]).id
    end
    if @user.update_attributes(user_params)
      flash[:success] = "This user has been updated"
      redirect_to admin_user_path(@user)
    else
      generate_flash(@user)
      render :edit
    end
  end

  def enable
    @user.update(enabled: true)
    flash[:success] = "The account for #{@user.name} is now enabled."
    redirect_to admin_users_path
  end

  def disable
    @user.update(enabled: false)
    flash[:success] = "The account for #{@user.name} is now disabled."
    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :zip, :email, :role, :merchant_id)
  end
end
