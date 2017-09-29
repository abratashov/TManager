require "rails_helper"

RSpec.describe Api::V1::CommentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/projects/1/tasks/1/comments").to route_to("api/v1/comments#index", :project_id => "1", :task_id => "1",)
    end

    it "routes to #create" do
      expect(:post => "/projects/1/tasks/1/comments").to route_to("api/v1/comments#create", :project_id => "1", :task_id => "1",)
    end

    it "routes to #destroy" do
      expect(:delete => "/projects/1/tasks/1/comments/1").to route_to("api/v1/comments#destroy", :project_id => "1", :task_id => "1", :id => "1")
    end

  end
end
