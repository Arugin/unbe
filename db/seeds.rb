#encoding: utf-8
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
  type_article = ArticleType.create ({:title => 'ARTICLE'})
  ArticleType.create ({:title => 'LESSON'})
  ArticleType.create ({:title => 'OVERVIEW'})
  type_news = ArticleType.create ({:title => 'NEWS'})

  puts 'CREATING Article Areas'
  area_no = ArticleArea.create ({:title => 'NO_AREA'})
  area_news = ArticleArea.create ({:title => 'NEWS'})
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
  no_cycle = Cycle.create ({:title => 'NO_CYCLE', :description =>"NO_CYCLE_DESC",:author => user})
  news = Cycle.create ({:title => 'Новости', :description =>"Новости сообщества unbe и не только",:author => user})
  Cycle.create ({:title => 'Зеркальный фотоаппарат', :description =>"Как держать камеру в руках и стоит ли её вообще держать в руках",:author => user})
  Cycle.create ({:title => 'Режиссерское дело своими глазами', :description =>"Рассказы о режиссерском деле, пропущенные сквозь призму своего опыта",:author => user})

  puts "CREATING articles"
  Article.create({title: "Об unbe",
                  content: "Всем известно, что кинопроизводство - очень закрытая и дорогая индустрия. Самый мизерный бюджет самого захудалого фильма исчисляется сотнями тысяч долларов. Он складывается из аренды оборудования (действительно, профессиональное оборудование иногда дешевле арендовать, чем приобрести), аренды съемочных площадок, декораций и костюмов, гонораров режиссерам, операторам, сценаристам, актерам первого плана, зарплаты персонала, расходников, электричества, налогов и сборов. Но бюджет — это наименьшая из бед.<br/><br/>Современную индустрию, в особенности российскую, пожирает жанровый голод, угнетает скудность идей, отсутствие творческого полета и даже отсутствие самого базового — профессионализма.<br/><br/>Большинство отсмотренных в кинотеатрах \"массового потребления\" сеансов оставляют неприятное ощущение потерянного времени и приближают к черте разочарованности в кинематографе в целом.<br/><br/>Закрытость всей этой системы не позволяет вдохнуть в неё новую жизнь свежими идеями, нестандартным мышлением, взглядом \"с другого ракурса\". А инерционность позволяет выдавать ей проекты, отвечающие стандартам качества двадцатилетней давности.<br/><br/>Остается лишь авторское кино, в большей мере бытовое или крайне нетрадиционное, имеющее крепкую постоянную аудиторию, правда довольно малую в масштабах индустрии, видеоблоггинг, получивший широчайшее распространение по всему миру, в основном благодаря сервису youtube, и любительские проекты, зачастую невысокого уровня исполнения, однако...<br/><br/><b>Цель</b> творческого объединение независимого кинопроизводства \"unbe\" — сделать систему открытой. Если вы чувствуете в себе способности режиссера, знаете как получить идеальный кадр, умеете выразить свои мысли через образ или действие, не против стать харизматичным злодеем или непривлекательным главным героем, можете из куска хлеба, проволоки и стакана сделать бутафорское ружье, не понаслышке знаете Adobe After Effects, с помощью тряпки и спичек воспроизводите и записываете шум дождя, или хотите чему-то из перечисленного научиться (а может и всему сразу), или вам просто это интересно — то это творческое объединение для вас.<br/><br/>Капля воды способна лишь нестись по течению, поток же может сточить камень. В сообществе людей, занимающихся любимым делом и заинтересованных в саморазвитии могут стихийно рождаться гениальные проекты, образовываться рабочие группы, появляться мастера своего дела.<br/><br/>Никто не говорит о жемчужинах и классике кинопрома, но просто жемчужин станет больше. И тогда, возможно, современная система кое-что поймет, снимет шляпу, поклонится и уступит место новому",
                  cycle: no_cycle,
                  article_type: type_article,
                  article_area: area_no,
                  created_at: DateTime.parse("2013-06-28 08:14:00"),
                  isPublished: true,
                  isApproved: true
                 })
  Article.create({title: "Эпизод 1. \"Чудеса\"",
                  content: "Сегодня были отсняты материалы для эпизода 1. Ребята хорошо потрудились. Съемки заняли четыре часа времени, а бюджет эпизода впервые чуть было не сдвинулся со стандартной отметки в 0 руб. Но ребята справились с этой проблемой, с чем мы их и поздравляем.",
                  cycle: news,
                  article_type: type_news,
                  article_area: area_news,
                  created_at: DateTime.parse("2011-03-25 12:00:00"),
                  isPublished: true,
                  isApproved: true
                 })
  Article.create({title: "Эпизод 3 \"Ребятки\"",
                  content: "Завершен съемочный день третьего эпизода. Материалы готовы к монтажу, эффектам и переозвучке. Скоро на экранах!",
                  cycle: news,
                  article_type: type_news,
                  article_area: area_news,
                  created_at: DateTime.parse("2011-04-03 09:53:00"),
                  isPublished: true,
                  isApproved: true
                 })
  Article.create({title: "Проект \"Кум\" приостановлен",
                  content: "После монтирования и отсмотра материалов наступает момент, когда необходимо делать выводы и решать, в каком направлении будет двигаться проект. После тщательного анализа, просмотра и долгих споров было принято <i>решение</i>. В связи с отсутствием опыта, харизмы и камеры работы над сериалом \"Кум\" приостановлены на неопределенный срок",
                  cycle: news,
                  article_type: type_news,
                  article_area: area_news,
                  created_at: DateTime.parse("2011-06-30 03:50:00"),
                  isPublished: true,
                  isApproved: true
                 })
  Article.create({title: "Деятельность \"unbe\" приостановлена",
                  content: "С прискорбием сообщаем, что по не зависящим от нас обстоятельствам, деятельность unbe приостанавливается на неопределенный срок. Будем ждать новостей и <b>надеяться</b>.",
                  cycle: news,
                  article_type: type_news,
                  article_area: area_news,
                  created_at: DateTime.parse("2011-08-31 03:15:00"),
                  isPublished: true,
                  isApproved: true
                 })
  Article.create({title: "Деятельность сообщества unbe восстановлена",
                  content: "<p>На самом деле деятельность была восстановлена ещё 01.10.2012, с регистрацией официального <a href=\"http://www.youtube.com/user/unbecinema\" title=\"Канал на youtube\">канала</a>, но информационные ресурсы имеют тенденцию развиваться чуть более чем медленно, поэтому эта новость дошла сюда только сегодня. Открываем бутылку колы и отправляемся бороздить просторы кино, да будет оно не русским! </p><p>Путь же неудачи станут уроком, а не камнем преткновения, и пусть хорошие работы заполонят наш канал.</p>",
                  cycle: news,
                  article_type: type_news,
                  article_area: area_news,
                  created_at: DateTime.parse("2013-07-21 18:36:00"),
                  isPublished: true,
                  isApproved: true
                 })
  puts "Articles were created"
end
