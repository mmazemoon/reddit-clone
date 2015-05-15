# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  validates :email, :username, :password_digest, :session_token, presence: true
  validates :email, :username, :session_token, uniqueness: true
  validate :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  def self.generate_session_token
    token = SecureRandom.urlsafe_base64

    while User.find_by(:session_token: token)
      token = SecureRandom.urlsafe_base64
    end

    token
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token!
    self.session_token= User.generate_session_token
    self.save!
    session_token
  end

  def password=(password)
    @password = password
    self.password_digest= BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end




end
