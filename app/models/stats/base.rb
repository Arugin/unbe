module Stats
  class Base < ActiveRecord::Base
    def articles_count
      Article.where(state: 'Article::Approved').not_in(article_area: ArticleArea.where(title: "NEWS").first).count
    end

    def users_count
      User.all.count
    end

    def percentage(value, max_value)
      (self.send("#{value.to_s}_count")/max_value.to_f)*100
    end

    def content_count
      Content::BaseContent.where(approved_to_news: true).count
    end

  end
end