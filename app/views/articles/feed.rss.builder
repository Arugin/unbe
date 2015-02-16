#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Творческое киносообщество unbe"
    xml.author "unbe"
    xml.description "Качественное кино, статьи о киноиндустрии, независимые работы"
    xml.link "http://unbe.ru"
    xml.language "ru"

    @articles.each do |article|
      xml.item do
        xml.title html_escape(article.title)
        xml.author article.author.name
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link article_url(article)
        xml.guid article.id

        xml.description html_escape(article.tiny_content)
      end
    end
  end
end