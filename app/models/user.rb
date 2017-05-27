class User < ApplicationRecord
  validates_length_of :first_name, :minimum => 3, :maximum => 6
  
  has_many :listings
  has_many :saved_listings
  has_many :messages
  validates :first_name, presence: true
  validates :last_name, presence: true

  attr_accessor :email_confirmation
  validates :email, confirmation: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def fullname
    "#{first_name.titleize} #{last_name.titleize}"
  end
end
