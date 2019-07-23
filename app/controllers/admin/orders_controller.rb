class Admin::OrdersController < Admin::BaseController
  def update
    @order = Order.find(params[:id])
    @order.update(status: "shipped")
    redirect_to admin_dashboard_path
  end

  def index
    @orders = Order.all.sort_by_status
  end
end
