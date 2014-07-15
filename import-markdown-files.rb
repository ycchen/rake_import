# /Users/yungchih/Dropbox (nclud)/SCLA (1)/Focus Portals/*/Content/* Content 1
# /Users/yungchih/Dropbox (nclud)/SCLA (1)/Focus Portals/Financial/Content/Financial Content 1

# filenames = Dir.glob("#{Dir.pwd}/**/*.md")
def load_files
	content_dir = Dir.glob("/Users/yungchih/Documents/Focus Portals/**")

	# Dir.glob(content_dir).select {|f| puts f}
	Dir.glob(content_dir).each do |folder|
		
		current_portal = folder.split("/").last.strip
		@portal = 1
		puts '@portal = Portal.find(name: current_portal)'
		# puts 'Folder name:' + folder

		Dir.glob(folder+ '/Content/**/*.md').each do |markdown_file|
			if markdown_file.size > 0
					puts "\n"+'Filename:' + markdown_file + "\n\n"

					puts '@article = Article.new'
					puts '@article.school_year = 1'
					puts '@article.school_session = 1'
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
										puts 'TITLE:' + value
										puts '@article.title =' + value
									when 'tags'
										add_skills(value,@portal)
										@article_skills.push(*value.split(",").map(&:strip))
									when 'skills'
										add_skills(value,@portal)
										@article_skills.push(*value.split(",").map(&:strip))
									when 'habits'
										add_skills(value,@portal)
										@article_skills.push(*value.split(",").map(&:strip))
									else
										puts 'line:' + i.to_s + line
										@mycontent  += line		
									end
							else
								puts 'line:' + i.to_s + line
								@mycontent  += line
							end #end of line.match(/.*:.*/)

					end #end of each line
					puts '@article.content = ' + @mycontent
					puts @article_skills.map(&:strip).join(',')
					puts '@article.skills << ' 
					puts '@article.save'
					#article.save

			end #end of if markdown_file.size >=0
		end #end of Dir.glob(/Content/**/*.md)
	end #end of Dir(content_dir)

end
# membership = student.build_membership(membership_since: Date.today, membership_until: 1.year.from_now)

def add_skills(skills,portal)
	skills.split(",").each do |skill|
			puts '@skill = Skill.find_or_create_by(name: skill, portal: portal)'
	end
	# puts skills.split(",").map(&:strip)
end

load_files
