class TasksController < ApplicationController
  before_filter :authenticate_staff!
  load_and_authorize_resource

  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = Task.sort(params[:sort])
    
    @numRows = 0
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end
  
  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new(:expires => true, :time => -1, :start_date => Time.now.at_beginning_of_day, :end_date => Time.now.at_beginning_of_day)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end
  
  # GET /tasks/1/edit
  def edit
    # @task automatically loaded by CanCan
  end
  
  # POST /tasks
  # POST /tasks.xml
  def create
    
    params[:task][:time] = parse_task_time(params[:task][:time],params[:anytime][:anytime])
    @task = Task.new(params[:task])
    
    # unless the following 2 commands are executed, the time is saved in the wrong time zone
    @task.start_date = @task.start_date.advance({:hours=>0})
    @task.end_date = @task.end_date.advance({:hours=>0})
    # can't understand why...
    
    respond_to do |format|
      if @task.save
        format.html { redirect_to(tasks_url, :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    params[:task][:time] = parse_task_time(params[:task][:time])
    
    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to(tasks_url, :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    
    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  #this method converts a time from hours and minutes to just total minutes past midnight
  def parse_task_time(time,anytime)
    if anytime == "true"
      return -1
    end
    time = Time.parse(time)
    return (time.hour*60) + time.min
  end
end
