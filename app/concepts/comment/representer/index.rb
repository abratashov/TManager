module Comment::Representer
  class Index < Base::Representer::JsonApiCollection
    items decorator: Comment::Representer::Show,
          wrap: false
  end
end
