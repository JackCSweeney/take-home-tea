require 'rails_helper'

RSpec.describe ErrorMessage do
  describe 'initialize' do
    it 'exists' do
      error = ErrorMessage.new("Validation failed: something something")

      expect(error).to be_a(ErrorMessage)
      expect(error.message).to eq("Validation failed: something something")
    end
  end
end