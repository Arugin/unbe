# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

begin
  puts 'CREATING GENDERS'
  Gender.create ({:name => 'UNKNOWN'})
  Gender.create ({:name => 'MALE'})
  Gender.create ({:name => 'FEMALE'})

  puts 'CREATING Article Types'
  ArticleType.create ({:title => 'ARTICLE'})
  ArticleType.create ({:title => 'LESSON'})
  ArticleType.create ({:title => 'OVERVIEW'})
  ArticleType.create ({:title => 'NEWS'})

  puts 'CREATING Article Areas'
  ArticleArea.create ({:title => 'NO_AREA'})
  ArticleArea.create ({:title => 'NEWS'})
  ArticleArea.create ({:title => 'DIRECTION'})
  ArticleArea.create ({:title => 'SHOOTING'})
  ArticleArea.create ({:title => 'SOUND'})
  ArticleArea.create ({:title => 'ACTING'})
  ArticleArea.create ({:title => 'SCREENWRITING'})
  ArticleArea.create ({:title => 'PROPS'})
  ArticleArea.create ({:title => 'POSTPRODUCTION'})
  ArticleArea.create ({:title => 'MANAGEMENT'})

  puts 'CREATING Default user'
  user = User.create! :name => 'Arugin', :email => 'unbecinema@gmail.com', :password => 'welcome', :password_confirmation => 'welcome'

  puts 'CREATING cycles'
  no_cycle = Cycle.create ({:title => 'NO_CYCLE', :description =>"NO_CYCLE_DESC",:creator => user})
  news = Cycle.create ({:title => 'Новости', :description =>"Новости сообщества unbe и не только",:creator => user})
  Cycle.create ({:title => 'Зеркальный фотоаппарат', :description =>"Как держать камеру в руках и стоит ли её вообще держать в руках",:creator => user})
  Cycle.create ({:title => 'Режиссерское дело своими глазами', :description =>"Рассказы о режиссерском деле, пропущенные сквозь призму своего опыта",:creator => user})


end
