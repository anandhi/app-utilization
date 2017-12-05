Rails.application.routes.draw do
  get 'app_utilization/cpu'

  get 'app_utilization/disk'
  get 'app_utilization/network'
  root to: "app_utilization#cpu"

  resource :app_utilization do
    get :cpu
  end
end
