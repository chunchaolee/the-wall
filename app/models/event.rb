class Event < ApplicationRecord
  # 一個event可以有很多筆被interest的資料
  has_many :interests
  # 一個event可以被很多user interest
  has_many :interested_users, through: :interests, source: :user

end
