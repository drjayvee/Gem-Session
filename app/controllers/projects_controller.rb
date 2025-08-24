# frozen_string_literal: true

require "securerandom"

class ProjectsController < ApplicationController

  allow_unauthenticated_access only: %i[ new new_form ] # to reel users in

  before_action :set_project, only: %i[ show edit update destroy ]

  # GET /projects or /projects.json
  def index
    @projects = Current.user.projects
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    if authenticated?
      @streamable = "chat_" + SecureRandom.uuid
      CreateProjectJob.perform_later @streamable
    end
  end

  def new_form
    @project = CreateProject.create.call # _slow_
    render formats: :turbo_stream
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.user = Current.user

    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    redirect_to projects_path, status: :see_other, notice: "Project was successfully destroyed."
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params.expect(:id))

      head :forbidden unless @project.user == Current.user
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.expect(project: [ :prompt, :homepage_url, rubygem_ids: [] ])
    end
end
