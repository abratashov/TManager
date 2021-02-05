module Base::Operation
  class Base < Trailblazer::Operation
    def scope(user:, res:)
      "#{res}Policy::Scope".constantize.new(user, res).resolve
    end
  end
end
