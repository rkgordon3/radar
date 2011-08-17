class TaskAssignmentsController < ApplicationController
  load_and_authorize_resource
  
  # GET /to_do_list
  # GET /to_do_list.xml
  def to_do_list
    if current_staff.on_duty?
      @task_assignments = current_staff.currently_assigned_tasks
    end
    
    respond_to do |format|
      format.html # to_do_list.html.erb
      format.xml  { render :xml => @task_assignments }
    end
  end
  
  # GET /task_assignments/new
  # GET /task_assignments/new.xml
  def new
    @task_assignment = TaskAssignment.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task_assignment }
    end
  end
  
  # GET /task_assignments/1/edit
  def edit
    @task_assignment = TaskAssignment.find(params[:id])
  end
  
  # POST /task_assignments
  # POST /task_assignments.xml
  def create
    @task_assignment = TaskAssignment.new(params[:task_assignment])
    
    respond_to do |format|
      if @task_assignment.save
        format.html { redirect_to(@task_assignment, :notice => 'Task assignment was successfully created.') }
        format.xml  { render :xml => @task_assignment, :status => :created, :location => @task_assignment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task_assignment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /task_assignments/1
  # PUT /task_assignments/1.xml
  def update
    @task_assignment = TaskAssignment.find(params[:id])
    
    respond_to do |format|
      if @task_assignment.update_attributes(params[:task_assignment])
        format.html { redirect_to(@task_assignment, :notice => 'Task assignment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task_assignment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /task_assignments/1
  # DELETE /task_assignments/1.xml
  def destroy
    @task_assignment = TaskAssignment.find(params[:id])
    @task_assignment.destroy
    
    respond_to do |format|
      format.html { redirect_to(task_assignments_url) }
      format.xml  { head :ok }
    end
  end
end
