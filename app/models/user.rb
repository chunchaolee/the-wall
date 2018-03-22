class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :spotify]

  validates_presence_of :name

  # 一個user可以有很多筆interest資料
  has_many :interests, dependent: :destroy
  # 一個user可以interest很多event
  has_many :interested_events, through: :interests, source: :event

  # 一個user可以有很多筆view資料
  has_many :views, dependent: :destroy
  # 一個user可以view很多event
  has_many :viewed_events, through: :views, source: :event

  # 一個user可以有很多筆notification資料
  has_many :notifications, dependent: :destroy
  # 一個user可以收到很多notification來自不同的event
  has_many :notified_events, through: :notifications, source: :event


  def interested?(event)
    self.interested_events.include?(event)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] &&  session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      elsif data = session["devise.spotify_data"] &&  session["devise.spotify_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|      
      user.provider = auth.provider
      user.uid      = auth.uid
      user.email    = auth.info.email
      user.name     = auth.info.name
      # user.facebook = auth.info.urls.Facebook
      user.password = Devise.friendly_token[0,20]
      # user.remote_avatar_url   = auth.info.image
      # user.skip_confirmation!  # 如果 devise 有使用 confirmable，記得 skip！
    end
  end

  def admin?
    self.is_admin == true
  end


end
