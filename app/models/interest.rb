class Interest < ApplicationRecord
  # 每一筆interst資料只屬於一個user
  belongs_to :user
  # 每一筆interst資料只對應到一個event
  belongs_to :event
end
