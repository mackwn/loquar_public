require 'csv'
MAX_ANSWERS = 4
namespace :migrate do
    desc 'import lesson with complete questions from csv'
    task lessons: :environment do
        Answer.delete_all
        Question.delete_all
        Lesson.delete_all
        
        
        filename = File.join Rails.root, "exercises_loquar_8-29-17.csv"
        @current_lesson = ''
        @lesson = ''
        @lesson_counter = 1
        @question_counter = 1
        ##add counter to say how many questions added for each lesson and how many total answers
        CSV.foreach(filename, headers:true) do |row|
            if @current_lesson != row["Lesson"] then
                @current_lesson = row["Lesson"]
                @lesson = Lesson.create(name: @current_lesson,id: @lesson_counter)
                @lesson_counter += 1
                puts "new lesson saved: #{@current_lesson}" if @lesson.save
                puts "#{@current_lesson} - #{@lesson.errors.full_messages.join(",")}" if @lesson.errors.any?
                
            end
            
            question = Question.create(id: @question_counter, content: row["content"],lesson_id: @lesson.id,category: row["category"])
            puts "#{row["content"]} - #{question.errors.full_messages.join(",")}" if question.errors.any?
            @question_counter += 1
            (MAX_ANSWERS-1).times do |x|
                if not row["answer#{x+1}"].nil? then
                    answer = Answer.create(content: row["answer#{x+1}"],question_id: question.id)
                    puts "#{row["answer#{x+1}"]} - #{answer.errors.full_messages.join(",")}" if answer.errors.any?
                end
            end
            
            
        end
    
        
        #for each lesson, look at the text that has that ID
    end
    
end
    
    

