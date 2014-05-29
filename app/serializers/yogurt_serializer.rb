class YogurtSerializer < ActiveModel::Serializer
  attributes :id, :topping, :quantity, :flavor
end
