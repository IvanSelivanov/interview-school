Rails.application.routes.draw do
  get 'sections/index'
  get 'sections/enroll'
  get 'sections/leave'
  # get 'sections/list'
  resources :classrooms
  resources :teachers do
    resources :teacher_subjects, shallow: true
  end
  resources :subjects
  root to: 'subjects#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
