class View < ApplicationRecord
  # 每一筆view資料只屬於一個user
  belongs_to :user
end
