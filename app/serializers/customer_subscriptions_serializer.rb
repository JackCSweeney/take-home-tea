class CustomerSubscriptionsSerializer
  def self.serialize(subscriptions)
    {
      data: 
      {
        subscriptions:
        {
          active: subscriptions.active,
          cancelled: subscriptions.cancelled
        }
      }
    }
  end
end