class LessonsController < ApplicationController
  load_and_authorize_resource param_method: :lesson_params
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  after_action :set_new_question_lesson_id, only: :edit
  require "#{Rails.root}/lib/points_functions.rb"

  # GET /lessons
  # GET /lessons.json
  def index
    @lessons = Lesson.order("id ASC")
    if user_signed_in?
      pf = PointsFunctions.new
      @les_points = pf.points_to_pass(current_user.level-1,pf.q_per_level,pf.pass_rate)
    end
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show #This controller manages the lesson
    
    #validate request
    redirect_to(root_path) and return unless user_signed_in?
    pf = PointsFunctions.new
    les_points = pf.points_to_pass(@lesson.id-1,pf.q_per_level,pf.pass_rate)
    redirect_to(root_path) and return if (@lesson.id > current_user.level or current_user.points < les_points)
    
    
    if @lesson.id == session[:lesson_id] then #no question redos
      redirect_to(find_question_path) and return if session[:question_state] == "answered"
      redirect_to(victory_screen_path) and return if session[:question_state] == "failed"
      redirect_to(victory_screen_path) and return if session[:question_state] == "finished"
      @question = Question.find_by(id: session[:question_id])
      logger.debug "Answers: #{session[:answers]}"
    end
    
    #set message for sending feedback
    @message = FeedbackMsg.new
    #don't render a question if it's a new lesson
    ###if you have type blanks, get a vocab index
        if session[:answer_type] = "type_blanks"
            @vocab_list = Question.where(lesson_id: session[:lesson_id], category: "vocab").select("content").collect {|verba| verba.content}
        end
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit
    @questions = @lesson.questions.all
  end

  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)
    logger.debug "lesson params: #{lesson_params}"
    respond_to do |format|
      if @lesson.save
        format.html { redirect_to edit_lesson_url(@lesson), notice: 'Lesson was successfully created.' }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to edit_lesson_url(@lesson), notice: 'Lesson was successfully updated.' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to lessons_url, notice: 'Lesson was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      params.require(:lesson).permit(:name,:content)
    end
    
    #new question
    def set_new_question_lesson_id
      session[:new_question_lesson_id] = @lesson.id
    end
end
