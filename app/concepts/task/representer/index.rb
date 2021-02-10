module Task::Representer
  class Index < Base::Representer::JsonApiCollection
    items decorator: Task::Representer::Show,
          wrap: false
  end
end
