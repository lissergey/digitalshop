class AddSpecificationToListings < ActiveRecord::Migration
  def change
    add_column :listings, :specification, :text
  end
end
