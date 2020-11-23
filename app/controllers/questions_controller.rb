class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:edit, :new]
  before_action :set_lesson, only: [:edit, :update, :destroy]
  after_action :set_new_answer_question_id, only: :edit
  load_and_authorize_resource

  # GET /questions
  # GET /questions.json
  def index
    redirect_to root_path and return if !(user_signed_in?) or !(current_user.is? :admin)
    @questions = Question.all
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    redirect_to root_path and return if !(user_signed_in?) or !(current_user.is? :admin)
  end

  # GET /questions/new
  def new
    @question = Question.new
    @lesson = Lesson.find_by(id: session[:new_question_lesson_id])
  end

  # GET /questions/1/edit
  def edit
    #@lesson = Lesson.find(@question.lesson_id)
    @answers = @question.answers.all
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    @lesson = Lesson.find_by(id: session[:new_question_lesson_id])
    @question.lesson_id = @lesson.id

    respond_to do |format|
      if @question.save
        format.html { redirect_to edit_lesson_path(@lesson), notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    #@lesson = Lesson.find(@question.lesson_id)
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to edit_question_path(@question), notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to edit_lesson_path(@lesson), notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:category, :content, :image)
    end
    
    def set_categories
      @categories = ["vocab","translation-lat","translation-eng"]
    end
    
    def set_lesson
      @lesson = Lesson.find(@question.lesson_id)
    end
    
    def set_new_answer_question_id
      session[:new_answer_question_id] = @question.id
    end
    
end
