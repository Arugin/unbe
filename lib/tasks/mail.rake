namespace :mail do
  desc "Sending an email with latest articles to users"
  task last_articles: :environment do
    require 'last_articles_mailer'
    User.all.each do |user|
      if user.subscribed
        LastArticlesMailer.articles(user).deliver!
      end
    end
  end
end