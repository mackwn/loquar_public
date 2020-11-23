class AnsweringController < ApplicationController
    require "#{Rails.root}/lib/answering_functions.rb"
    require "#{Rails.root}/lib/points_functions.rb"
    def start_lesson
      pf = PointsFunctions.new
      les_id = params[:new_less][:lesson_id].to_i 
      les_points = pf.points_to_pass(les_id-1,pf.q_per_level,pf.pass_rate)
      redirect_to(root_path) and return if (les_id > current_user.level and current_user.points >= les_points)
      session[:lesson_id] = les_id
      session[:question_id] = "start"
      session[:question_state] = "start"
      session[:lesson_content] = generate_lesson(les_id)
      session[:lesson_index] = 0
      session[:score] = 0
      #don't have a live system for reviewing lessons (should not be punished for reviewing)
      #current_user.level == les_id ? session[:lesson_lives] = 3 : session[:lesson_lives] = nil
      #taking a different route....
      session[:lesson_lives] = 3
        
      
      redirect_to find_question_path
    end
    
    def victory_screen
        #this makes sense since later on one might want to add
        #additional things to the victory splash such as game stats etc
        @q_state = session[:question_state]
        
        if @q_state == "finished"
            pf = PointsFunctions.new
            @lesson = Lesson.find_by(id: session[:lesson_id])

            
            if (@next_les = Lesson.find_by(id: session[:lesson_id]+1)).nil?
                @course_comp = true
            else
                @course_comp = false
            end
            
            @next_les_points = pf.points_to_pass(@lesson.id,pf.q_per_level,pf.pass_rate)
            
            logger.debug "question state: #{session[:question_state]}"
           
            
            #made sure the victory screen can only be accessed once
            
        
        elsif @q_state == "failed"
            pf = PointsFunctions.new
            @lesson = Lesson.find_by(id: session[:lesson_id])
            @next_les_points = pf.points_to_pass(@lesson.id,pf.q_per_level,pf.pass_rate)
            @les_points = pf.points_to_pass(@lesson.id-1,pf.q_per_level,pf.pass_rate)
            @lost_points = pf.points_per_question(@lesson.id,current_user.level)*3
            @can_continue = current_user.points - @lost_points + session[:score] >= @les_points
        
        else
            redirect_to(root_path) and return
            
            
        end
        
        
        
    end
    

    
    
    def submit
        #Validate request
        logger.debug "state: #{session[:question_state] == "answered"}"
        redirect_to(root_path) and return if params[:submission][:question_id].to_i != session[:question_id]
        redirect_to(find_question_path) and return if session[:question_state] == "answered"
        redirect_to(find_question_path) and return if session[:question_state] == "finished"
        redirect_to(find_question_path) and return if session[:question_state] == "failed"
        session[:question_state] = "answered"
        @submission = params[:submission][:submission]
        @question = Question.find_by(id: params[:submission][:question_id])
        #@lesson = Lesson.find_by(id: @question.lesson_id)
        
        ####ANSWERING CHECKING
        @answers = Answer.where(question_id: @question.id)
        #good opportunity to write a function that would be @question.correct_answer?(@submssion)
        #this would probably be better abstracted by having a model for submissions
        # @submission.correct?
        @qcorrect = check_answer(@question,@submission)
        @answer_cont = Answer.find_by(id: params[:submission][:answer_id]).content
        if @qcorrect  
            pf = PointsFunctions.new
            #!!!!!!!!!!!!replace below with some sort of temp points earned variable, save the points after lesson complete (done)
            session[:score] += pf.points_per_question(session[:lesson_id],current_user.level) if session[:lesson_id] == current_user.level
            #current_user.save
        else
            session[:lesson_lives] -= 1 if session[:lesson_id] == current_user.level
        end
        
        #AJAX control
        respond_to do |format|
            format.html {redirect_to question_path(@question)}
            format.js 
        end
    end
    
    def find_question
        logger.debug "find_question gets triggered"
        redirect_to(root_path) and return if session[:question_state].nil? #no question if no lesson started
        
        #####Check if failure conditions are met
        if session[:lesson_lives] != nil and session[:lesson_lives] < 0
           session[:question_state] = "failed" 
           session[:lesson_lives] = 3 
           respond_to do |format|
                format.html { redirect_to(victory_screen_path)}
                format.js do 
                    logger.debug "responds to the right JS..."
                    redirect_to(victory_screen_path)
                end
            end
            return
        end
        #####Check if victory conditions are met
        if session[:lesson_index] == session[:lesson_content].count
            complete_lesson #add point assignment and level up
            logger.debug "complete lesson triggered"
            respond_to do |format|
                format.html { redirect_to(victory_screen_path)}
                format.js do 
                    logger.debug "responds to the right JS..."
                    redirect_to(victory_screen_path)
                end
            end
            return
        end
        #####Subtract points and reset lesson if failed lesson
        if session[:question_state] == "failed"
            pf = PointsFunctions.new
            les_points = pf.points_to_pass(session[:lesson_id]-1,pf.q_per_level,pf.pass_rate)
            lost_points = pf.points_per_question(session[:lesson_id],current_user.level)*3
            redirect_to(victory_screen_path) and return if current_user.points - lost_points + session[:score] < les_points
            session[:score] -= lost_points
            #current_user.save
            session[:lesson_index] -= 1
            session[:question_state] == "answered"
        end
        
        if session[:question_state] == "finished"
            redirect_to victory_screen_path and return
        end
        
        #validate the request to get a new question
        
        @state = session[:question_state]
        logger.debug "state #{@state}"
        if @state == "unanswered" then #no skipping questions
            redirect_to lesson_path(session[:lesson_id])
            return
        end
        session[:question_state] = "unanswered" #prepare for next question
        
        #New question picking
        @question_id = session[:question_id]

        @question = pick_question(@question_id)
        logger.debug "ques #{@question}"
        logger.debug "question picked"
        session[:question_id] = @question.id
        answer_collection = get_answer_choices(@question)
        session[:answers_choices] = answer_collection[:choices]
        session[:answers_type] = answer_collection[:type]
        session[:answer_id] = answer_collection[:answer_id]
        ###if you have type blanks, get a vocab index
        if session[:answer_type] = "type_blanks"
            @vocab_list = Question.where(lesson_id: session[:lesson_id], category: "vocab").select("content").collect {|verba| verba.content}
        end
        
        logger.debug "answer id: #{answer_collection[:answer_id]}"
        logger.debug "get answer choices called"
        logger.debug "Answers: #{session[:answers_choices]}"
        
        #Ajax handlign
        respond_to do |format|
            format.html {redirect_to lesson_path(Lesson.find_by(id: session[:lesson_id]))}
            format.js {
                @lesson = Lesson.find_by(id: session[:lesson_id])
                @message = FeedbackMsg.new ### added so that feedback form works with json
            }
        end
    end
    
    
    private
    
    def complete_lesson
        ####this needs to be filled in to properly reset all
        ###of the session variables and level up the user
        ##!!!below should change, no level up until you've actually earned that many points
        pf = PointsFunctions.new
        if current_user.level == session[:lesson_id]
            current_user.points += session[:score]
            current_user.save
        end
        if current_user.level == session[:lesson_id] and current_user.points > pf.points_to_pass(session[:lesson_id],pf.q_per_level,pf.pass_rate)
            current_user.level = session[:lesson_id] + 1
            current_user.save
        end
        
        ##!!!assign points earned for the lesson and determine if user has enough points to progress a level
        session[:lesson_content] = nil
        session[:lesson_index] = nil
        
        session[:question_id] = nil
        session[:question_state] = "finished"
        
        
    end
    
    
    def pick_question(question_id)
        if question_id == "start"
            
        end
        @question = Question.find_by(id: session[:lesson_content][session[:lesson_index]])
        logger.debug "lesson_content: #{session[:lesson_content]}"
        logger.debug "index: #{session[:lesson_index]}"
        session[:lesson_index] += 1
        
        
        return @question
    ######WHAT DOOO?!
    end
    
    def get_answer_choices(question)
        afunctions = AnsweringFunctions.new
        case question.category
        when "vocab"
            afunctions.find_mult_choice(question)
        when "translation-lat"
            afunctions.find_select_blanks(question)
        when "translation-eng"
            afunctions.find_type_blanks(question)
        end
    end
    
    def generate_lesson(lesson_id)
        q_ids = []
        if current_user.level == session[:lesson_id]
            cats = ["vocab","translation-lat","translation-eng"]
            rand_qs = Question.where("lesson_id < ?",lesson_id).select("id")
            rand_qs_count = rand_qs.count
            cats.each do |cat|
                cat_qs = Question.where(lesson_id: lesson_id,category: cat ).select("id").shuffle
                cat_qs = cat_qs.first(4) if cat_qs.count > 4
                cat_set = [] #separate variable so each category can be shuffled
                cat_qs.each do |vocab|
                    cat_set << vocab.id
                    (cat_set << rand_qs.offset(rand(rand_qs_count)).first.id if 
                        rand() < 0.25) if rand_qs.count > 0
                end
            q_ids += cat_set.shuffle
            end
            if q_ids.count < 15
                extra = 15 - q_ids.count
                extra_qs = Question.where(lesson_id: lesson_id).select("id")
                extra_q_ids = extra_qs.offset(rand(extra_qs.count)).first(extra).collect { |a| a.id } 
                q_ids += extra_q_ids
            
            end
        else
            rand_qs = Question.where("lesson_id < ?",lesson_id).select("id").shuffle.first(3)

            cat_qs = Question.where(lesson_id: lesson_id).select("id").shuffle
            logger.debug "cat qs: #{cat_qs.count}"
            cat_qs = cat_qs.first(12) if cat_qs.count > 12
            q_ids += cat_qs.collect { |a| a.id } 
            q_ids += rand_qs.collect { |a| a.id }
            q_ids = q_ids.shuffle
            
        end
        return q_ids
    end
    
    def check_answer(question,submission)
        answers = Answer.where(question_id: question.id)
        qcorrect = false


        answers.each do |answer|
             
             if answer.content.strip.casecmp(submission.strip) == 0
                 qcorrect = true and break  
             end
             
        end
        
       # unless qcorrect
            #rand_qs = Question.where(lesson_id: question.lesson_id).select("id")
           # session[:lesson_content] += rand_qs.offset(rand(rand_qs.count)).first(2).map {|x| x.id}
       # end
        
    
            
        
        return qcorrect
    end
    
    
    
end
