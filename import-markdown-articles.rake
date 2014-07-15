namespace :articles do
	desc "Import markdown articles"
	task :import, [:filename] => :environment do
		
		content_dir = Dir.glob("/Users/yungchih/Documents/Focus Portals/**")
		Dir.glob(content_dir).each do |folder|
			
			puts current_portal = folder.split("/").last.strip

			@portal = Portal.where(name: current_portal).first

			Dir.glob(folder+ '/Content/**/*.md').each do |markdown_file|
				if markdown_file.size > 0
						@article = Article.new
						@article.school_year_id = 1
						@article.school_session_id = 1
						@mycontent =''
						@article_skills = []

						File.open(markdown_file, 'r').each_line.with_index do |line,i|
							i += 1 if i == 0
							# If the line has a ':', check for meta-data
								if line.match(/.*:.*/)
									key, value = line.split(":", 2)
									key = key.strip.downcase
									value = value.to_s.strip
									
									case key
										when 'title'
											puts 'TITLE:|' + value.strip+'|'
											@article.title = value.strip
										when 'tags', 'skills', 'habits'
											skillz = add_skills(value,@portal)
											skillz.each do |skill|
											 	@article.skills << skill
											end
										else
											@mycontent  += line		
										end
								else
									@mycontent  += line
								end #end of line.match(/.*:.*/)

						end #end of each line
						@article.content =  @mycontent
						@article.skills <<  @article_skills
						@article.save if Article.where(title: @article.title).blank?
				end #end of if markdown_file.size >=0
			end #end of Dir.glob(/Content/**/*.md)
		end #end of Dir(content_dir)

	end	# end of task
end # end of namespace

def add_skills(skills,portal)
		skills.split(",").collect do |skill|
			Skill.find_or_create_by(name: skill, portal: portal)
		end
		# puts skills.split(",").map(&:strip)
end
