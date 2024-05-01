require 'rails_helper'

RSpec.describe "Get All Customer Subscriptions" do
  before(:each) do
    @customer_1 = Customer.create!({first_name: "Test", last_name: "Last", email: "test@email.com", address: "1234 Test Dr. Los Angeles, CA 90034"})
    @customer_2 = Customer.create!({first_name: "Test Two", last_name: "Last Two", email: "testtwo@email.com", address: "1234 Test Dr. Los Angeles, CA 90034"})
    @tea_1 = Tea.create!({title: "Green", description: "Bright and zesty", temperature: 195, brew_time: 90})
    @tea_2 = Tea.create!({title: "Jasmine", description: "Bright and earthy", temperature: 195, brew_time: 100})
    @tea_3 = Tea.create!({title: "Oolong", description: "Savory", temperature: 200, brew_time: 100})

    @subscription_1 = Subscription.create!({title: @tea_1.title, price: 15.5, status: 1, frequency: 6, tea_id: @tea_1.id, customer_id: @customer_1.id})
    @subscription_2 = Subscription.create!({title: @tea_2.title, price: 25.5, status: 0, frequency: 12, tea_id: @tea_2.id, customer_id: @customer_1.id})
    @subscription_3 = Subscription.create!({title: @tea_3.title, price: 25.5, status: 1, frequency: 12, tea_id: @tea_3.id, customer_id: @customer_1.id})
    @subscription_4 = Subscription.create!({title: @tea_3.title, price: 25.5, status: 1, frequency: 12, tea_id: @tea_3.id, customer_id: @customer_2.id})

    @headers = {"CONTENT_TYPE" => "application/json"}
  end

  describe '#happy path' do
    it 'responds with a collection of all of a customers subscriptions, active and cancelled' do
      get "/api/v0/customers/subscriptions?customer_id=#{@customer_1.id}", headers: @headers

      expect(response).to be_successful
      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:data)
      expect(result[:data]).to be_a(Hash)
      
      data = result[:data]

      expect(data).to have_key(:subscriptions)
      expect(data[:subscriptions]).to be_a(Hash)

      subscriptions = data[:subscriptions]

      expect(subscriptions).to have_key(:active)
      expect(subscriptions[:active]).to be_a(Array)
      expect(subscriptions).to have_key(:cancelled)
      expect(subscriptions[:cancelled]).to be_a(Array)

      active = subscriptions[:active]

      expect(active.length).to eq(2)
      expect(active[0]).to have_key(:title)
      expect(active[0][:title]).to eq(@subscription_1.title)
      expect(active[0]).to have_key(:price)
      expect(active[0][:price]).to eq(@subscription_1.price)
      expect(active[0]).to have_key(:status)
      expect(active[0][:status]).to eq(@subscription_1.status)
      expect(active[0]).to have_key(:frequency)
      expect(active[0][:frequency]).to eq(@subscription_1.frequency)
      expect(active[0]).to have_key(:tea_id)
      expect(active[0][:tea_id]).to eq(@subscription_1.tea_id)
      expect(active[0]).to have_key(:customer_id)
      expect(active[0][:customer_id]).to eq(@subscription_1.customer_id)
      expect(active[1]).to have_key(:title)
      expect(active[1][:title]).to eq(@subscription_3.title)
      expect(active[1]).to have_key(:price)
      expect(active[1][:price]).to eq(@subscription_3.price)
      expect(active[1]).to have_key(:status)
      expect(active[1][:status]).to eq(@subscription_3.status)
      expect(active[1]).to have_key(:frequency)
      expect(active[1][:frequency]).to eq(@subscription_3.frequency)
      expect(active[1]).to have_key(:tea_id)
      expect(active[1][:tea_id]).to eq(@subscription_3.tea_id)
      expect(active[1]).to have_key(:customer_id)
      expect(active[1][:customer_id]).to eq(@subscription_3.customer_id)

      cancelled = subscriptions[:cancelled]

      expect(cancelled[0]).to have_key(:title)
      expect(cancelled[0][:title]).to eq(@subscription_2.title)
      expect(cancelled[0]).to have_key(:price)
      expect(cancelled[0][:price]).to eq(@subscription_2.price)
      expect(cancelled[0]).to have_key(:status)
      expect(cancelled[0][:status]).to eq(@subscription_2.status)
      expect(cancelled[0]).to have_key(:frequency)
      expect(cancelled[0][:frequency]).to eq(@subscription_2.frequency)
      expect(cancelled[0]).to have_key(:tea_id)
      expect(cancelled[0][:tea_id]).to eq(@subscription_2.tea_id)
      expect(cancelled[0]).to have_key(:customer_id)
      expect(cancelled[0][:customer_id]).to eq(@subscription_2.customer_id)
    end
  end

  describe '#sad path' do
    it 'will return the correct error response if given an id that does not exist' do
      get "/api/v0/customers/subscriptions?customer_id=123123123123", headers: @headers

      expect(response).not_to be_successful
      expect(response.status).to eq(404)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:errors)
      expect(result[:errors]).to be_a(Array)
      expect(result[:errors].first).to have_key(:detail)
      expect(result[:errors].first[:detail]).to eq("Couldn't find Customer with 'id'=123123123123")
    end
  end
end