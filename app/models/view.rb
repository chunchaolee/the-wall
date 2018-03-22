class View < ApplicationRecord
  # 每一筆view資料只屬於一個user
  belongs_to :user
  # 每一筆view資料只對應到一個event
  belongs_to :event     # 刪除 :counter_cache => true，避免刪除重複的 view 時減少 views_count
end
