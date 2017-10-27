module Api
  module V1
    class ProjectResource < JSONAPI::Resource
      attributes :name
    end
  end
end
