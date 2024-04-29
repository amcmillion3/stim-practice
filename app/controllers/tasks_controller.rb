class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all.group_by(&:status)
  end

  def new
    @task = Task.new
  end

  def show
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      respond_to do |format|
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
        format.turbo_stream { redirect_to tasks_path, notice: 'Task was successfully updated.' }
      end
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: 'Task was successfully destroyed.' }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@task) }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :developer, :status)
  end
end
