class Event < ApplicationRecord
  # 一個event可以有很多筆被interest的資料
  has_many :interests, dependent: :destroy
  # 一個event可以被很多user interest
  has_many :interested_users, through: :interests, source: :user

  # 一個event可以有很多筆被view的資料
  has_many :views, dependent: :destroy
  # 一個event可以被很多user view
  has_many :viewed_users, through: :views, source: :user

  # 一個event可以有很多筆要notification的資料
  has_many :notifications, dependent: :destroy
  # 一個event可以對很多user送出notification
  has_many :notified_users, through: :notifications, source: :user

end
