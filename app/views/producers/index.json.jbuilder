json.array!(@producers) do |producer|
  json.extract! producer, :id, :name
  json.url producer_url(producer, format: :json)
end
