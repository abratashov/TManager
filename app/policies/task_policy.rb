class TaskPolicy < ApplicationPolicy
  attr_reader :user, :task

  def initialize(user, task)
    @user = user
    @task = task
  end

  def index?
    true
  end

  def show?
    task.project.user_id == @user.id
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
      @user.tasks
    end
  end
end
