namespace :notification do
  task event: :environment do

    
    today  = (Time.now + 7.days) .to_s
    puts today.split(' ')[0]

    events = Event.where(date: today.split(' ')[0])
    if !events.empty?
      puts "Have record"
      events.all.each do |event|
        puts event.title
        puts event.date
        puts event.id
        interests = Interest.where(event_id: event.id)
        if !interests.empty? 
          puts "record"
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
        else
          puts "No record"
        end
      end
    #end
    else
      puts "No record"
    end

  end
end