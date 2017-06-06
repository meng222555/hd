class User < ApplicationRecord
  # extend FriendlyId
  # friendly_id :slug_candidates, use: :slugged # *** Must add slug col to users table ***

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

  # def friendlyize_email
  #   "#{first_name.titleize} #{last_name.titleize}"
  #   email.tr("@", "-").tr(".", "-")
  # end

  ## Try building a slug based on the following fields in
  ## increasing order of specificity.
  # def slug_candidates
  #   [
  #     :fullname,
  #     :friendlyize_email
  #   ]
  # end

end
