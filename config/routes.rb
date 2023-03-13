Rails.application.routes.draw do
  root 'main#index'
  get 'reports/', to: "reports#index"
  # get 'reports/report_by_category', to: 'reports#report_by_category'
  post 'reports/report_by_category', to: 'reports#report_by_category'
  get 'reports/report_by_dates'
  post 'reports/report_by_dates', to: 'reports#report_by_dates'
  resources :operations
  resources :categories
  # resources :reports, only: [ :index, :report_by_category, :report_by_dates ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
