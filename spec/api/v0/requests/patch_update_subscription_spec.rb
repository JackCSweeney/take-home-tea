require 'rails_helper'

RSpec.describe "Update Subscription via HTTP Patch Request" do
  before(:each) do
    @customer = Customer.create!({first_name: "Jack", last_name: "Sweeney", email: "test@email.com", address: "123 Test St. Los Angeles, CA 90034"})
    @tea = Tea.create!({title: "English Breakfast", description: "Black morning tea", temperature: 200, brew_time: 180})
    @subscription = Subscription.create!({tea_id: @tea.id, customer_id: @customer.id, price: 35, frequency: 12, status: 1, title: @tea.title})

    @headers = {"CONTENT_TYPE" => "application/json"}
    @body = {status: 0}
  end

  describe '#happy path' do
    it 'can cancel a subscription by sending an HTTP request to the correct endpoint with the new status in the body' do
      patch "/api/v0/subscriptions/#{@subscription.id}", headers: @headers, params: JSON.generate(@body)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:data)
      expect(result[:data]).to be_a(Hash)

      data = result[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).to be_a(String)
      expect(data).to have_key(:type)
      expect(data[:type]).to eq("subscription")
      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a(Hash)

      attributes = data[:attributes]

      expect(attributes).to have_key(:tea_id)
      expect(attributes[:tea_id]).to eq(@tea.id)
      expect(attributes).to have_key(:customer_id)
      expect(attributes[:customer_id]).to eq(@customer.id)
      expect(attributes).to have_key(:price)
      expect(attributes[:price]).to eq(35)
      expect(attributes).to have_key(:frequency)
      expect(attributes[:frequency]).to eq(12)
      expect(attributes).to have_key(:status)
      expect(attributes[:status]).to eq("cancelled")
    end
  end
end