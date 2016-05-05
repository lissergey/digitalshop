class CombineItemsInCart < ActiveRecord::Migration
  def up
    Cart.all.each do |cart|
      sums = cart.line_items.group(:listing_id).sum(:quantity)
      sums.each do |listing_id, quantity|
        if quantity > 1
          cart.line_items.where(listing_id: listing_id).delete_all
          item = cart.line_items.build(listing_id: listing_id)
          item.quantity = quantity
          item.save!
        end end
    end end
end
