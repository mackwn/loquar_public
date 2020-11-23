class AnsweringFunctions
    #Refactor so the controller just accesses one function from
    #answering functions. This will contain all the logic for deciding
    #which questions get what type of answer? 
    def find_mult_choice(question) #rename find choices for multiple choice
        #answer = ... should be in here no matter w hat - should always be first line
        answer_collection = {type: "mult_choice"}
        answer = question.answers.offset(rand(question.answers.count)).first
        @q_ids = [question.id]
        anss = pull_answers(question,2,true)
        anss+=(pull_answers(question,2,false))
        answer_collection[:choices] = anss.append(answer.content).shuffle
        answer_collection[:answer_id] = answer.id
        return answer_collection
    end
    
    def find_type_blanks(question)
        answer_collection = {type: "type_blanks"}
        blank_answers = generate_blanks(question)
        answer_collection[:choices] = blank_answers[:choices]
        answer_collection[:answer_id] = blank_answers[:answer_id]
    	return answer_collection
    end
    
    def find_select_blanks(question)
        no_choices = 4
        answer_collection = {type: "select_blanks"}
        blank_answers = generate_blanks(question)
        answer_collection[:answer_id] = blank_answers[:answer_id]
        blank_choices = []
        answer_words = blank_answers[:word_store].sort_by{|key,val| key}.map{|n| n[1]}
        puts(answer_words)
        generated_words = generate_rand_words(question,no_choices*answer_words.count)
        puts(generated_words)
        counter = 0
        answer_words.each do |word|
            wrong_choices = [word]
            no_choices.times do
                word == word.downcase ? wrong_choices << generated_words[counter] :
                    wrong_choices << generated_words[counter].capitalize

                
                counter+=1
            end
            blank_choices << wrong_choices.shuffle
        end
        answer_collection[:choices] = blank_answers[:choices] << blank_choices
        return answer_collection
    end
    
    
    
    
    #def find choices for fill in the blank.. function of (question)
    #needs to return the partial answer and a matrix of answers
    #[blank->{word, word, word}, blank->{word,word,word}]
    
    
    private
    def pull_answers(question,no_ans,same_lesson = false)
        anss = []
        same_lesson ? qs = Lesson.find_by(id: question.lesson_id).questions.where(category: question.category) :
            qs = Question.where(category: question.category)
        return false unless qs
        no_qs = qs.count
        (no_ans).times do
            loop do
                ques = qs.offset(rand(no_qs)).first
                if (!(@q_ids.include? ques.id) and ques.answers.count > 0) then

                    ans = ques.answers.offset(rand(ques.answers.count)).first
                    @q_ids.append(ques.id)

                    anss.append(ans.content)
                    break
                end
            end
        end
        return anss
    end
    
    def generate_rand_words(question,no_words)
        qs = Question.where("lesson_id <= ? AND category = ?",
            question.lesson_id,question.category)
        no_qs = qs.count
        words = []
        while words.count < no_words do
            ac = generate_blanks(qs.offset(rand(no_qs)).first)
            ###Replace with iterate (...).values.each do, 
            ###make sure words don't already exist in the word store
            words += ac[:word_store].values
        end
        return words.shuffle[0,no_words]
    end
    
    def mutate_lat_word(word)
    end
    
    def generate_blanks(question)
        poses=[]
        ignore_poses = []
    	word_store = {}
    	phrase = ''
        answer_collection = {}
        answer = question.answers.offset(rand(question.answers.count)).first
        answer_collection[:answer_id] = answer.id
        words = answer.content.split()
    	no_words = words.length
    	skips = 0
    	
    	words.each.with_index do |word,pos|	

    		if ["the","The","A","a","An","an"].include? word
    			ignore_poses << pos
    			skips += 1
    		end
	    end
	    
    	no_blanks = case no_words - skips
        	when 1
        		return false
        	when 2..4
        		2
        	when 5..8
        		3
        	else
        		4
        	end
    	
    	return false if no_blanks > no_words
    	no_blanks.times do |n|
    		pos = rand(no_words)
    		while ((poses.include? pos) or (ignore_poses.include? pos)) do
    			pos = rand(no_words)
    		end
    		puts(n)
    		poses << pos
    		puts(words[pos])
		end
		poses.sort!.each.with_index do |pos,n|	
    		word = words[pos]
    		# original regex /[[:alpha:]]+[[:punct:]]*[[:alpha:]]+\'*/
    		matcher = /([[:alpha:]]+[[:punct:]]*[[:alpha:]]+\'*|[[:alpha:]])/.match(word)
    		if matcher
    			n == 0 ? span_text = "<span id = \"#{n}-choice\" class=\"select-word select-word-selected\">___</span>" :
    			    span_text = "<span id = \"#{n}-choice\" class=\"select-word\">___</span>"
    			new_word  = word.sub(/([[:alpha:]]+[[:punct:]]*[[:alpha:]]+\'*|[[:alpha:]])/,span_text)
    			##should have some way of handling matcher fail?
    			puts(new_word)
    			words[pos] = new_word
    			word_store[n]=matcher[0]
    		else
    		    puts "matcher failed #{word}"
    		    no_blanks -= 1
    		end
    	end
    	words.each do |word|
    		phrase == '' ? phrase+=word : phrase+=' '+word	
    	end
    	puts(word_store)
    	answer_collection[:choices]=[phrase,no_blanks]
    	answer_collection[:word_store] = word_store
    	return answer_collection
        
    end
    
    
    #def mutate_word(word)
    # 
    
    
    
end

#to help test....
#require "#{Rails.root}/lib/answering_functions.rb"
#af = AnsweringFunctions.new
#q = Question.where(lesson_id: 3).first
#ac = af.find_select_blanks(q)
#ch1 = af.find_choices(q1)

