module Task::Contract
  class Create < Reform::Form
    property :name

    validation name: :default do
      required(:name).filled(:str?)
    end
  end
end
