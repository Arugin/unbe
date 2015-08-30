module Stats
  class Base
    def articles_count
      Article.joins(:article_area).where("article_areas.title NOT IN ('NEWS')").where(state: 'Article::Approved').count
    end

    def users_count
      User.all.count
    end

    def percentage(value, max_value)
      (self.send("#{value.to_s}_count")/max_value.to_f)*100
    end

    def content_count
      Content.where(approved_to_news: true).count
    end

  end
end