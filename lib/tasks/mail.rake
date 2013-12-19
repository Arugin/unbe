namespace :mail do
  desc "Sending an email with latest articles to users"
  task last_news: :environment do
    require 'last_news_mailer'
    User.all.each do |user|
      if user.subscribed
        LastNewsMailer.news(user).deliver!
      end
    end
  end
end