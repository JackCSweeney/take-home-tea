class CustomerSubscriptionsSerializer
  def self.serialize(subscriptions)
    {
      data: {
        active: subscriptions.active,
        cancelled: subscriptions.cancelled
      }
    }
  end
end