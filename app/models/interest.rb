class Interest < ApplicationRecord

  validates :event_id, uniqueness: { scope: :user_id }

  # 每一筆interst資料只屬於一個user
  belongs_to :user
  # 每一筆interst資料只對應到一個event
  belongs_to :event, :counter_cache => true
end
