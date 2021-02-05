module Project::Representer
  class Index < Base::Representer::JsonApiCollection
    items decorator: Project::Representer::Show,
          wrap: false
  end
end
