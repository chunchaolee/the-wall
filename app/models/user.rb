class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

end
