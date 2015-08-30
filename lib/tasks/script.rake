namespace :db do
	def collections
		[
			{ model: "Gender", table: "genders" },
			{ model: "Role", table: "roles" },
			{ model: "ArticleArea", table: "article_areas" },
			{ model: "ArticleType", table: "article_types" },
			{ model: "User", table: "users" },
			{ model: "Authentication", table: "authentications" },
			{ model: "Cycle", table: "cycles" },
			{ model: "Article", table: "articles" },
			{ model: "Comment", table: "comments" },
			{ model: "Image", table: "images" },
			{ model: "Gallery", table: "galleries" },
			{ model: "Content", table: "contents" },
			{ model: "PublicActivity::Activity", table: "public_acctivities" },
			{ model: "Merit::ActivityLog", table: "merit_activity_logs" },
			{ model: "Merit::Score::Point", table: "merit_score_points" },
			{ model: "Merit::BadgesSash", table: "merit_badges_sashes" },
			{ model: "Merit::Sash", table: "merit_sashes" },
			{ model: "Merit::Score", table: "merit_scores" },
			{ model: "Impression", table: "impressions" },
		]
	end

	task :export => :environment do
			collections.each do |collection|
				table = collection[:table]
				model = collection[:model]
				dir = "db/seed/" + Rails.env
				filename = dir + "/" + table + ".json"
				Dir.mkdir dir unless (Dir.exists? dir)
				Rake::Task["db:model:export"].execute({model: model, filename: filename})
			end
  end

	task :import => :environment do
		collections.each do |collection|
			table = collection[:table]
			model = collection[:model]
			dir = "result"
			filename = dir + "/" + table + ".json"
			Rake::Task["db:model:import"].execute({model: model, filename: filename})
		end
  end

	namespace :model do
		task :export, [:model, :filename] => :environment do |t, args|
		  model = args[:model].constantize
		  filename = args[:filename]
		  objects = model.all
		  File.open(File.join(Rails.root, filename), "w") do |f|
			objects.each do |object|
			  f.write(object.to_json)
			  f.write("\r\n")
			end
		  end
		end
		task :import, [:model, :filename] => :environment do |t, args|
      p "Importing #{args[:model]}..."
		  model = args[:model].constantize
		  model.destroy_all
			model.skip_callback(:create)
		  filename = args[:filename]
		  File.foreach(File.join(Rails.root, filename)) do |line|
			  next if line.blank?
        attrs = JSON.parse(line.strip)
        object = model.new
				object.attributes = attrs.reject{|k,v| !object.attributes.keys.member?(k.to_s) }
			  object.save(validate: false)
      end
      sleep 1
		end
	end	
end