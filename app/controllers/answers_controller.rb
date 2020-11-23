class AnswersController < ApplicationController
  load_and_authorize_resource
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_question, only: [:edit, :update, :destroy]

  # GET /answers
  # GET /answers.json
  def index
    redirect_to root_path and return if !(user_signed_in?) or !(current_user.is? :admin)
    @answers = Answer.all
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
    redirect_to root_path and return if !(user_signed_in?) or !(current_user.is? :admin)
  end

  # GET /answers/new
  def new
    @answer = Answer.new
    session[:new_answer_question_id].nil? ? @question = Question.first : 
      @question = Question.find_by(id: session[:new_answer_question_id])
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  # POST /answers.json
  def create
    @answer = Answer.new(answer_params)
    @question = Question.find_by(id: @answer.question_id)
    redirect_to(new_answer_path, notice: "Invalid question id.") and return if @question.nil?
    #@answer.question_id = @question.id

    respond_to do |format|
      if @answer.save
        format.html { redirect_to edit_question_path(@question), notice: 'Answer was successfully created.' }
        format.json { render :show, status: :created, location: @answer }
      else
        format.html { render :new }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to edit_question_path(@question), notice: 'Answer was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to edit_question_path(@question), notice: 'Answer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:content, :question_id)
    end
    
    def set_question
      @question = Question.find(@answer.question_id)
    end
    
    
end
