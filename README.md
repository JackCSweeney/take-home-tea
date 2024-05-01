# Take Home Tea

This is an API only Rails application with intent to return information on different customers Tea subscriptions. To get this application up and running, you can clone down to your local machine, bundle, create and migrate database, and begin making requests to the endpoints after running the server. You can run the test suite with `bundle exec rspec` if RSpec has been installed.

The goal with this API was to deliver on the MVP that was requested while still leaving room in regards to flexibility for future development in the application, should there be any.

Some additional areas that I might add to first, given more time, would be including additional endpoints to return information for a specific tea and including tea information in the endpoint that returns active and cancelled subscriptions so front end would have less endpoints they might need to hit in order to get information they might be displaying on the front end.

### Versioning
- Rails 7.1.3.2
- Ruby 3.2.2

### Database Schema
- Customers
  - First name
  - Last name
  - Email (must be unique)
  - Address
- Teas
  - Title
  - Description
  - Temperature
  - Brew time
- Subscriptions
  - Title
  - Price
  - Status (enum for cancelled(0) and active(1))
  - Frequency (Integer for number of times per year)
  - Tea ID (Unique, scoped to Customer)
  - Customer ID

### Endpoints
- `POST "/api/v0/subscriptions"` Creates a new subscription from the data provided in the body of the request.
- Body:
```
{
  "tea_id" : 1,
  "customer_id" : 1,
  "price" : 15.5,
  "frequency" : 12,
  "status" : 1,
  "title" : "Oolong"
}
```
- Return:
```
{
  "data" : {
    "id" : "1"
    "type" : "subscription"
    "attributes" : {
      "tea_id" : "1",
      "customer_id" : "1",
      "price" : "15.5",
      "frequency" : "12",
      "status" : "1",
      "title" : "Oolong"
    }
  }
}
```

- `PATCH "/api/v0/subscriptions/:subscription_id"` Updates a subscription based on the id provided in the endpoint and attribute updates provided in the body of the request.
- Body: (Just needs to include attributes you wish to change)
```
{
  "status" : "0"
}
```
- Return:
```
{
  "data" : {
    "id" : "1"
    "type" : "subscription"
    "attributes" : {
      "tea_id" : "1",
      "customer_id" : "1",
      "price" : "15.5",
      "frequency" : "12",
      "status" : "0",
      "title" : "Oolong"
    }
  }
}
```

- `GET "/api/v0/customers/subscriptions?customer_id=1"` Returns all subscriptions, active and cancelled, for the customer provided in the endpoint.
- Return:
```
{
  "data" 
  {
    "subscriptions" :
    {
      "active" :
      [
        {
          "id" : "1",
          "customer_id" : "1",
          ...
        }
      ]
      "cancelled" :
      [
        {
          "id" : "2",
          "customer_id" : "1",
          ...
        }
      ]
    }
  }
}
```

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
