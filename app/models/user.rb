class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :confirmable, :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  acts_as_paranoid

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :signin

  # Setup accessible (or protected) attributes for your model
  attr_accessible :signin, :username, :email, :password, :password_confirmation, :remember_me

  validates :username, :uniqueness => true

  has_many :images, :as => :parent, :dependent => :destroy

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    signin = conditions.delete(:signin)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => signin.strip.downcase }]).first
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end
end
