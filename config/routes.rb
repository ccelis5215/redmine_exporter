Rails.application.routes.draw do
  resources :projects do
    member do
      get 'issue_exporter', to: 'issue_exporter#index', as: 'issue_exporter'
      post 'issue_exporter/export', to: 'issue_exporter#export', as: 'export_issues'
    end
  end
end