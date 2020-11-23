namespace :migrate do
    task lessonText: :environment do
        lesses = Lesson.all
        lesses.each do |les|
            if !les.content
                file_name = File.join Rails.root, "lesson_text/lesson_text_#{les.id}.html"
                les_file = File.open(file_name)
                if les_file
                    file_contents = les_file.read
                    les.content = file_contents
                    les.save
                    puts "text for lesson #{les.id}/#{les.name} saved" if les.save
                    puts "#{les.id} - #{les.errors.full_messages.join(",")}" if les.errors.any?
                end
            end
            
              
            
        end
    end
end
