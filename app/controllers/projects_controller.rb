class ProjectsController < ApplicationController

  before_action :authenticate_user!

  before_action :set_and_authorize_project!, only: %i[show edit update destroy]

  before_action :authorize_project_action!, only: %i[index new create]

  # GET /projects
  # GET /projects.json
  def index
    @projects = policy_scope(Project).page(params.fetch(:page, 1)).per(params.fetch(:per, 25))
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if project.save
        format.html { redirect_to project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: project }
      else
        format.html { render :new }
        format.json { render json: project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if project.update(project_params)
        format.html { redirect_to project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: project }
      else
        format.html { render :edit }
        format.json { render json: project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  attr_reader :project

  # Use callbacks to share common setup or constraints between actions.
  def set_and_authorize_project!
    @project = Project.find(params[:id])
    authorize_project_action!
  end

  def authorize_project_action!
    authorize project || Project
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(*Project.permitted_attributes)
  end
end
