module LessonsHelper
    #class for user state?
    #def set_current_lesson(lesson)
        #if lesson_id <= current_user.level then
        #session[:lesson_id] = lesson.id
    #end
    
    #def current_lesson
       # @lesson ||= Lesson.find_by(id: session[:lesson_id])
    #end
    require "#{Rails.root}/lib/points_functions.rb"
    
    def points_per_question(level,current_level)
        pf = PointsFunctions.new
        return pf.points_per_question(level,current_level)
    end
    
    def points_to_pass(level)
        pf = PointsFunctions.new
        return pf.points_to_pass(level,pf.q_per_level,pf.pass_rate)
    end
    
    
    
    
end
