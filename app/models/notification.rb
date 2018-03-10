class Notification < ApplicationRecord
  # 每一筆notification資料只屬於一個user
  belongs_to :user
end
