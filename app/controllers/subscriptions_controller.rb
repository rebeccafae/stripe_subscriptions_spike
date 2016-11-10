class SubscriptionsController < ApplicationController
  before_action :get_user
  before_action :find_subscription_id, only: :destroy

  def new
  end

  def create
    @customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken],
      plan: "gold"
    )
    @user.update stripe_id: @customer.id, active_until: subscription_end_date

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path
  end

  def destroy
    subscription = Stripe::Subscription.retrieve(@subscription_id)

    if subscription.delete(:at_period_end => true)
      @user.update active_until: nil
      redirect_to user_path(@user), notice: 'Subscription was successfully cancelled.'
    else
      redirect_to user_path(@user), alert: 'Something went wrong, please try again.'
    end
  end

  private

  def get_user
    id = (params[:id] or params[:user_id])
    @user = User.find id
  end

  def find_subscription_id
    customer = Stripe::Customer.retrieve @user.stripe_id
    @subscription_id = customer.subscriptions.data.first.id
  end

  def subscription_end_date
    @customer.subscriptions.data.first.current_period_end
  end
end
