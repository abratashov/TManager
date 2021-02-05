class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def index?
    true
  end

  def show?
    project.user_id == @user.id
  end

  def create?
    show?
  end

  def new?
    create?
  end

  def update?
    show?
  end

  def edit?
    show?
  end

  def destroy?
    show?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @user.projects
    end
  end
end
