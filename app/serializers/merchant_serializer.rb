class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  has_many :items, if: Proc.new { |merchant| merchant.items.any? }
end
