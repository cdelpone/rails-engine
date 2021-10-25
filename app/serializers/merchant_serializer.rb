class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  has_many :items, if: Proc.new { |merchant| merchant.items.any? }

  # has_many :items, serializer: ItemSerializer, links: {
  #   self: api_v1_merchant_path,
  #   related: -> (merchant) {
  #     api_v1_merchant_items_path
  #   }
  # }
end
