require 'rails_helper'
# rspec spec/models/transaction_spec.rb
RSpec.describe Transaction, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }

    # it 'has the right index' do
    #   results.each_with_index do |item, index|
    #     expect(Transaction.results[item]).to eq(index)
    #   end
    # end
    #
    # it 'successful scope returns successful results' do
    #   expect(Transaction.successful).to eq([transaction])
    # end
  end
end
