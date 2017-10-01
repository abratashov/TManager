Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api do
    namespace :v1 do
      resources :projects do
        resources :tasks do
          resources :comments, except: [:show, :update]
        end
      end
    end
  end

  resources :projects, module: 'api/v1' do
    resources :tasks do
      resources :comments, except: [:show, :update]
    end
  end

  get '/apidocs' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.yml')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
