#to help test....
#require "#{Rails.root}/lib/points_functions.rb"
#pf = PointsFunctions.new
#pf.ppq_current_level(
#pf.points_to_pass(
#pf.points_per_question(

class PointsFunctions
    def points_per_question(level,current_level)
        #using quadratic drop off for review levels
        a = (0.5 * (current_level-1))/((current_level-1)**2)

        if level == 1 or level >= current_level
            return (ppq_current_level(level))
        else
            return (1 + a*(level-1)**2)

        end
        
    end
    
    def points_to_pass(level,q_per_level,pass_rate)
        ppl = 0.25*level*(level+3) #partial sum of current level pp formula
        return (ppl*q_per_level*pass_rate)
        
    end
    
    def q_per_level
        return 45
    end
    
    def pass_rate
        return 0.8
    end
    
    
    private
    
    def ppq_current_level(current_level)
        return 1 + 0.5*(current_level-1)
    end
    

end
