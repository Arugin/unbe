FactoryGirl.define do
  factory :content_base_content, class: Content::BaseContent do
    title "My content"
    src 'http://www.youtube.com/watch?v=zqrBkgrzLik'
  end
end