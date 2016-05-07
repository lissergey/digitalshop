class AddProducerIdToListings < ActiveRecord::Migration
  def change
    add_column :listings, :producer_id, :integer
  end
end
