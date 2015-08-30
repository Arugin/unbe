#encoding: utf-8
begin
  Role.create(
      [{:name => 'ADMIN'},
       {:name => 'USER'},
       {:name => 'MODERATOR'},
       {:name => 'READER'}
      ])
  Gender.create :name => 'UNKNOWN'
  @male = Gender.create :name => 'MALE'
  Gender.create :name => 'FEMALE'

  ArticleType.create :title => 'ARTICLE'
  ArticleType.create :title => 'LESSON'
  ArticleType.create :title => 'OVERVIEW'
  ArticleType.create :title => 'NEWS'
  ArticleType.create :title => 'TRANSLATE'
  ArticleType.create :title => 'NOTE'

  ArticleArea.create :title => :NO_AREA
  ArticleArea.create :title => :NEWS
  ArticleArea.create :title => :DIRECTION
  ArticleArea.create :title => :SHOOTING
  ArticleArea.create :title => :SOUND
  ArticleArea.create :title => :ACTING
  ArticleArea.create :title => :SCREENWRITING
  ArticleArea.create :title => :PROPS
  ArticleArea.create :title => :POSTPRODUCTION
  ArticleArea.create :title => :MANAGEMENT
end
