Rails.application.routes.draw do
  devise_for :users
  resources :trees, param: :slug
  get "/all_trees", to: "trees#all_trees", as: :all_trees
  get "home/index"
  root "home#index"

  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
end
