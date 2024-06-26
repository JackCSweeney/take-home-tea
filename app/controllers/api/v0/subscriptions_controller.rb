class Api::V0::SubscriptionsController < ApplicationController
  def create
    subscription = Subscription.create!(subscription_params)
    render json: SubscriptionSerializer.new(subscription), status: 201
  end

  def update
    subscription = Subscription.find(params[:id])
    subscription.update!(subscription_params)
    render json: SubscriptionSerializer.new(subscription), status: 200
  end

  private
  def subscription_params
    params.require(:subscription).permit(:price, :tea_id, :customer_id, :status, :frequency, :title)
  end
end