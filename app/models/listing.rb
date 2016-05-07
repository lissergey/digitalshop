class Listing < ActiveRecord::Base

  if Rails.env.development?
    has_attached_file :image, :styles => { medium: "50x50>", thumb: "50x50>" }, :default_url => "default.jpg" , :resize_to_fit => [200, 300]
  else
    has_attached_file :image, :styles => { :medium => "50x", :thumb => "5x50>" }, :default_url => "default.jpg",
                      :storage => :dropbox,
                      :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
                      :path => ":style/:id_:filename"
  end
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates :name, :description, :price, :specification, presence: true
  validates :price, numericality: {greater_than:  0}
  validates_attachment_presence :image

  searchkick

  has_many :line_items
  has_many :reviews
  belongs_to :category
  belongs_to :producer

  before_destroy :ensure_not_referenced_by_any_line_item

  private

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'существуют товарные позиции')
      return false
    end
  end

end
