namespace :notification do
 # 活動黃金週通知信
 task event: :environment do
   today  = (Time.now + 7.days) .to_s
   puts today.split(' ')[0]

   events = Event.where(date: today.split(' ')[0])
   if !events.empty?

     events.all.each do |event|
       # puts event.title
       # puts event.date
       # puts event.id
       interests = Interest.where(event_id: event.id)
       if !interests.empty? 

         interests.all.each do | interest |
           puts interest.user_id
            NotificationMailer.event_notification(interest).deliver_now!
           # user = JSON.parse(User.where(id: interest.user_id).to_json).first

           # puts user['name']

           # if !user.empty?
           #   puts user['name']
           #   # puts user.name
           # else
           #   puts "No User"
           # end 
         end
       end
     end
   end

 end

 # 電子報
 task news_letter: :environment do
   # 判斷每周一執行
   # 0~6 日~六, 1:星期一
   monday = 1 
   if Time.now.wday == monday
     # for test
     # user = JSON.parse(User.where('email = ?', 'your@gmail.com').to_json).first
     
     events = [] 
     # # created_at
     # 上週新建立的event, 
     today  = (Time.now - 7.days).to_s
     newly_events = Event.where('created_at > ?' , today.split(' ')[0]).limit(5).order('date asc')
     events << newly_events

     # interests_count/views_count 
     # 熱門event, 先以關注最多挑選五則,  未來可考慮瀏覽次數views
     hot_events = Event.order('interests_count DESC').limit(5).order('date asc')
     events << newly_events
     
     if !newly_events.empty? or !hot_events.empty?
       # 後續要考慮有認證過的mail才發送, 要篩選過
       users = User.all
       if !users.empty?
         users.all.each do |user|
           begin
             NewsLetterMailer.weekly_notification(events, user).deliver_now!
           rescue
             puts $!
             next
           end
         end
         puts "#{users.all.count} users, will get weekly mail"
       end
     end
   end
 end
end