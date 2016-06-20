class User < ActiveRecord::Base
  attr_reader :password

  has_many :cats

  has_many :rental_requests,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: "CatRentalRequest"

  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}

  after_initialize :ensure_session_token

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)

    return if user.nil?
    return user if user.is_password?(password)
  end

  # This method is called when the user signs up and creates a
  # username and password. The @password is never saved, but is used
  # to create a password digest.
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest) == password
  end



  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
  end

  protected
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end
end
