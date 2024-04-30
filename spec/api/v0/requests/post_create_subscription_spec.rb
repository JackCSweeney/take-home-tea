require 'rails_helper'

RSpec.describe "Create New Subscription via HTTP Request" do
  before(:each) do
    @customer = Customer.create!({first_name: "Jack", last_name: "Sweeney", email: "test@email.com", address: "123 Test St. Los Angeles, CA 90034"})
    @tea = Tea.create!({title: "English Breakfast", description: "Black morning tea", temperature: 200, brew_time: 180})

    @headers = {"CONTENT_TYPE" => "application/json"}
    @body = {tea_id: @tea.id, customer_id: @customer.id, price: 35, frequency: 12, status: 1, title: @tea.title}
    @bad_body_1 = {customer_id: @customer.id, price: 35, frequency: 12, status: 1, title: @tea.title}
    @bad_body_2 = {tea_id: @tea.id, customer_id: @customer.id, price: 35, frequency: 12, status: 1}
  end

  describe '#happy path' do
    it 'can create a new subscription for a customer with the tea they selected through a post request to the api' do
      post "/api/v0/subscriptions", headers: @headers, params: JSON.generate(@body)

      expect(response).to be_successful
      expect(response.status).to eq(201)

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
      expect(attributes[:status]).to eq("active")
    end
  end

  describe '#sad path' do
    it 'will not create a record if the request is missing information' do
      post "/api/v0/subscriptions", headers: @headers, params: JSON.generate(@bad_body_1)

      expect(response).not_to be_successful
      expect(response.status).to eq(422)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:errors)
      expect(result[:errors]).to be_a(Array)
      expect(result[:errors].first).to be_a(Hash)
      expect(result[:errors].first[:detail]).to eq("Validation failed: Tea must exist")

      post "/api/v0/subscriptions", headers: @headers, params: JSON.generate(@bad_body_2)

      expect(response).not_to be_successful
      expect(response.status).to eq(422)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:errors)
      expect(result[:errors]).to be_a(Array)
      expect(result[:errors].first).to be_a(Hash)
      expect(result[:errors].first[:detail]).to eq("Validation failed: Title can't be blank")
    end

    it 'will not create a new record if an existing subscription for the customer has the same tea_id' do
      post "/api/v0/subscriptions", headers: @headers, params: JSON.generate(@body)
      
      expect(response).to be_successful

      post "/api/v0/subscriptions", headers: @headers, params: JSON.generate(@body)

      expect(response).not_to be_successful
      expect(response.status).to eq(422)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:errors)
      expect(result[:errors]).to be_a(Array)
      expect(result[:errors].first).to be_a(Hash)
      expect(result[:errors].first[:detail]).to eq("Validation failed: Tea has already been taken")
    end
  end
end