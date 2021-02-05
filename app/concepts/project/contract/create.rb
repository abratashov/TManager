module Project::Contract
  class Create < Reform::Form
    property :name

    validation name: :default do
      required(:name).filled(:str?)
    end

    include Project::Contract::Base
  end
end
