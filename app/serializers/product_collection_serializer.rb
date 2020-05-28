class ProductCollectionSerializer < ActiveModel::Serializer
  # This isn't totally necessary. Just
  # remember that once we've added our
  # serializer for the show action, the
  # data will show up in that format in
  # our previously set up index action.
  # This is just a way to maintain a
  # different set of attributes for the
  # index or other actions.
  attributes(
    :id,
    :title,
    :description,
    :price,
    :created_at,
    :updated_at
  )
end
