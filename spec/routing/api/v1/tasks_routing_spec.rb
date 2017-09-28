require "rails_helper"

RSpec.describe Api::V1::TasksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/projects/1/tasks").to route_to("api/v1/tasks#index", :project_id => "1",)
    end


    it "routes to #show" do
      expect(:get => "/projects/1/tasks/1").to route_to("api/v1/tasks#show", :project_id => "1", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/projects/1/tasks").to route_to("api/v1/tasks#create", :project_id => "1",)
    end

    it "routes to #update via PUT" do
      expect(:put => "/projects/1/tasks/1").to route_to("api/v1/tasks#update", :project_id => "1", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/projects/1/tasks/1").to route_to("api/v1/tasks#update", :project_id => "1", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/projects/1/tasks/1").to route_to("api/v1/tasks#destroy", :project_id => "1", :id => "1")
    end

  end
end
