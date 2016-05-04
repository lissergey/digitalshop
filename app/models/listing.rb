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

  belongs_to :category
end
