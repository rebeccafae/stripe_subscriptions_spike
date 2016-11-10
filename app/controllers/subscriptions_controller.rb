class SubscriptionsController < ApplicationController
  def new
  end

  def create
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken],
      plan: "gold"
    )

    user = User.find params[:user_id]
    user.update stripe_id: customer.id, active_until: 1.month.from_now

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path
  end
end
