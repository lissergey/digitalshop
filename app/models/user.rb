class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true

  has_many :listing, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
