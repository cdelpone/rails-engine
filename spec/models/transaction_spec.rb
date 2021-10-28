require 'rails_helper'
# rspec spec/models/transaction_spec.rb
RSpec.describe Transaction, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
  end
end
