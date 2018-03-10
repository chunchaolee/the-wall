class Interest < ApplicationRecord
  # 每一筆interst資料只屬於一個user
  belongs_to :user
end
