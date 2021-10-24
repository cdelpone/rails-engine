require 'rails_helper'
# rspec spec/models/invoice_item_spec.rb
RSpec.describe InvoiceItem, type: :model do
  describe 'relationships/validations' do
    it { should belong_to :item }
    it { should belong_to :invoice }
  end
end
