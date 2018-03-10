class Event < ApplicationRecord
  # 一個event可以有很多筆被interest的資料
  has_many :interests
end
