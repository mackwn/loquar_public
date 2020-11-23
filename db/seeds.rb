# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


user = User.new(

      :email                 =>  ENV["ADMIN_ACCOUNT"],
      :password              =>  ENV["ADMIN_PASSWORD"],
      :password_confirmation =>  ENV["ADMIN_PASSWORD"],
      :role                  => "admin"
  )
  user.skip_confirmation!
  user.save!
=begin  
lessons = Lesson.create([{name: 'Basics'}, {name: 'A-Declension'},{name: 'O-Decelension'}])

3.times do |n|
    @content = "word#{n}"
    @category = "vocab"
    lessons.each { |lesson| lesson.questions.create!(content: @content, category: @category)}
end

3.times do |n|
    @content = "sentence#{n}"
    @category = "translation"
    lessons.each { |lesson| lesson.questions.create!(content: @content, category: @category)}
end

questions = Question.all

2.times do |n|
    @content = "Responsum#{n}"
    questions.each { |question| question.answers.create!(content: @content) }
end
=end
        
        
    
    