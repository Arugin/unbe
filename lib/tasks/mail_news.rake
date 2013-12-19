namespace :mail do
  desc "Sending an email with latest articles to users"
  task(:last_news => :environment) do
    User.all.each do |user|
      if user.subscribed
        LastNewsMailer.news(user).deliver!
      end
    end
  end
end