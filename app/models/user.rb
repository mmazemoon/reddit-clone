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
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  has_many(
    :subs,
    class_name: 'Sub',
    foreign_key: :moderator_id,
    primary_key: :id
  )

  has_many(
    :posts,
    class_name: 'Post',
    foreign_key: :author_id,
    primary_key: :id
  )

  attr_reader :password

  def self.generate_session_token
    token = SecureRandom.urlsafe_base64

    while User.find_by(session_token: token)
      token = SecureRandom.urlsafe_base64
    end

    token
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil unless user && user.is_password?(password)
    user
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
