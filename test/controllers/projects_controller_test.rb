require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
  end

  def login(user = :jay)
    post session_path, params: { email_address: users(user).email_address, password: "password" }
  end

  test "should get index" do
    get projects_url
    assert_response :success
    assert_match @project.prompt, response.body
    refute_match projects(:two).prompt, response.body, "Only published projects should be shown"
  end

  test "should get new" do
    get new_project_url
    assert_response :success
  end

  test "should create project" do
    login

    assert_difference("Project.count") do
      post projects_url, params: { project: { rubygem_ids: @project.rubygems.map(&:id), prompt: @project.prompt, homepage_url: @project.homepage_url } }
    end

    assert_redirected_to project_url(Project.last)
  end

  test "should show published project" do
    get project_url(@project)
    assert_response :success
  end

  test "should show unpublished project only to owner" do
    get project_url(@project)
    assert_response :success
  end

  test "should get edit" do
    login

    get edit_project_url(@project)
    assert_response :success
  end

  test "should update project" do
    login

    patch project_url(@project), params: { project: { prompt: @project.prompt, homepage_url: @project.homepage_url } }
    assert_redirected_to project_url(@project)
  end

  test "should destroy project" do
    login

    assert_difference("Project.count", -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
  end

  test "actions must restrict access to other users' projects" do
    login
    project = projects(:two)

    [
      -> { get project_url(project) },
      -> { get edit_project_path(project) },
      -> { patch project_path(project) },
      -> { delete project_path(project) },
    ].each do |action|
      action.call
      assert_response :forbidden
    end
  end
end
