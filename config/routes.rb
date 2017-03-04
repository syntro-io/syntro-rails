TestDB::Application.routes.draw do
  resources :stencils
  # Get the test plans for a product (for assignment form)
  get 'stencils/update_test_plan_select/:id', controller: 'stencils', action: 'update_test_plan_select'
  # The route below is somewhat dangerous, but is actually a dumby.
  # In order to make the test plan jquerywork in the schedule form, we make this fake url
  # and then append the id in javascript. This should newver be called directly. Only the line above should be called
  # you must use the :as path for new and edit forms
  get 'stencils/update_test_plan_select/', controller: 'stencils', action: 'update_test_plan_select', as: 'jquery_matrix_test_plan_update'
  get 'stencils/create_new_version/:id', controller: 'stencils', action: 'create_new_version', as: 'create_new_stencil_version'

  resources :tags

  resources :schedules
  # Get the test plans for a product (for assignment form)
  get 'schedules/update_test_plan_select/:id', controller: 'schedules', action: 'update_test_plan_select'
  # The route below is somewhat dangerous, but is actually a dumby.
  # In order to make the test plan jquerywork in the schedule form, we make this fake url
  # and then append the id in javascript. This should newver be called directly. Only the line above should be called
  # you must use the :as path for new and edit forms
  get 'schedules/update_test_plan_select/', controller: 'schedules', action: 'update_test_plan_select', as: 'jquery_schedule_test_plan_update'

  resources :devices

  resources :custom_fields

  # Web API v1 route
  post 'webapi/run'

  # Web API v2 routes
  post 'api/:object/:endpoint', to: 'webapiv2#run',       via: [:post]
  post 'api/*other',            to: 'webapiv2#invalid',   via: [:post]

  resources :tasks do
    resources :comments
  end
  get 'my/tasks/', controller: 'tasks', action: 'my_index', as: 'my_tasks'

  resources :reports
  # Get the versions for a product (for reports form)
  get 'reports/update_version_select/:id', controller: 'reports', action: 'update_version_select'
  # The route below is somewhat dangerous, but is actually a dumby.
  # In order to make the uodate_version_select jquerywork in the reports form, we make this fake url
  # and then append the id in javascript. This should newver be called directly. Only the line above should be called
  # you must use the :as path for new and edit forms
  get 'reports/update_version_select/', controller: 'reports', action: 'update_version_select', as: 'jquery_report_version_update'
  # Run a report
  get 'reports/run/:id', controller: 'reports', action: 'run', as: 'run_report'

  resources :results
  get 'results/:id/compare', controller: 'results', action: 'compare', as: 'compare_results'

  resources :assignments do
    resources :tasks
  end

  # Get the versions and test plans for a product (for assignment form)
  get 'assignments/update_version_select/:id', controller: 'assignments', action: 'update_version_select'
  get 'assignments/update_test_plan_select/:id', controller: 'assignments', action: 'update_test_plan_select'
  get 'assignments/update_stencil_select/:id', controller: 'assignments', action: 'update_stencil_select'
  get 'assignments/update_ticket_issues_select/:productid/:versionid', controller: 'assignments', action: 'update_ticket_issue_select'
  # The 2 routes below below somewhat dangerous, but are actually dumbies.
  # In order to make the uodate_version_select and test plan jquerywork in the assignments form, we make this fake url
  # and then append the id in javascript. This should newver be called directly. Only the line above should be called
  # you must use the :as path for new and edit forms
  get 'assignments/update_version_select/', controller: 'assignments', action: 'update_version_select', as: 'jquery_assignment_version_update'
  get 'assignments/update_test_plan_select/', controller: 'assignments', action: 'update_test_plan_select', as: 'jquery_assignment_test_plan_update'
  get 'assignments/update_stencil_select/', controller: 'assignments', action: 'update_stencil_select', as: 'jquery_assignment_stencil_update'
  get 'assignments/update_ticket_issues_select/', controller: 'assignments', action: 'update_ticket_issue_select', as: 'jquery_assignment_ticket_issue_update'

  # Download an attachment
  # Had to swap to asterisk. Called globbing. Used in case there is filename with multiple periods.
  get 'uploads/:id/:style/*filename.:format', controller: 'uploads', action: 'download', conditions: { method: :get }

  resources :settings

  resources :categories

  # Create a new category at the product level
  get 'category/new/product/:product_id', controller: 'categories', action: 'new_product', as: 'new_product_category'
  # Create a new category at the sub-category level
  get 'category/new/category/:category_id', controller: 'categories', action: 'new_category', as: 'new_subcategory'
  # List categories belonging to a product (for category module)
  get 'category/list/:product_id', controller: 'categories', action: 'list', as: 'list_product_categories'
  # List categories belonging to another category (for category module)
  get 'category/list_children/:category_id', controller: 'categories', action: 'list_children', as: 'list_category_children'
  # List categories belonging to a product (for test case module)
  get 'test_cases/list/:product_id', controller: 'test_cases', action: 'list', as: 'list_test_case_categories', defaults: { format: 'js' }
  # List categories belonging to another category (for test case module)
  get 'test_cases/list_children/:category_id', controller: 'test_cases', action: 'list_children', as: 'list_test_case_category_children'
  # List categories belonging to a product (for test plan module)
  get 'test_plans/:plan_id/list_categories/:product_id', controller: 'test_plans', action: 'list_categories', as: 'list_test_plan_categories'
  # List categories belonging to another category (for test plan module)
  get 'test_plans/:plan_id/list_category_children/:category_id', controller: 'test_plans', action: 'list_category_children', as: 'list_test_plan_category_children'
  # Add a test case to a test plan
  get 'test_plans/:plan_id/add_case/:id', controller: 'test_plans', action: 'add_test_case', as: 'add_test_case_to_plan'
  # Remove a test case from a test plan
  get 'test_plans/:plan_id/remove_case/:id', controller: 'test_plans', action: 'remove_test_case', as: 'remove_test_case_from_plan'
  get 'test_plans/copy/:id', controller: 'test_plans', action: 'copy', as: 'copy_test_plan'

  # URLs for logging in and out of the application
  get 'login', controller: 'user_sessions', action: 'new', as: 'login'
  get 'logout', controller: 'user_sessions', action: 'destroy'

  # List test plans belonging to a product (used on test plan index view)
  get 'test_plans/list/:product_id', controller: 'test_plans', action: 'list', as: 'list_test_plans'

  resources :user_sessions

  resources :authentications, except: :destroy do
    get :delete, action: :destroy
  end
  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/failure', to: 'authentications#failure'

  get 'users/import/', controller: 'users', action: 'import', as: 'import_user'
  resources :users
  get 'users/:id/reset', controller: 'users', action: 'reset', as: 'reset_user'
  get '/my_settings' => 'users#my_settings', :as => 'my_settings'
  get '/update_settings' => 'users#update_my_settings', :as => 'update_my_settings'

  resources :uploads do
    member do
      get 'executable'
    end
  end
  resources :versions
  get 'versions/update_ticket_version_select/:id', controller: 'versions', action: 'update_ticket_version_select'
  get 'versions/update_ticket_version_select/', controller: 'versions', action: 'update_ticket_version_select', as: 'jquery_version_ticket_version_update'

  get '/test_plans/search/', controller: 'test_plans', action: 'search', as: 'test_plan_search'
  resources :test_plans do
    resources :comments
  end
  get 'test_plans/create_new_version/:id', controller: 'test_plans', action: 'create_new_version', as: 'create_new_test_plan_version'

  # Load the admin page
  get 'admin/index', as: 'admin'

  resources :test_types

  resources :products

  get '/test_cases/search/', controller: 'test_cases', action: 'search', as: 'test_case_search'
  resources :test_cases do
    resources :comments
  end
  get 'test_cases/new/import/', controller: 'test_cases', action: 'import', as: 'import_new_test_case'
  post 'test_cases/new/import/', controller: 'test_cases', action: 'import_create', as: 'import_create_test_case'
  get 'test_cases/create_new_version/:id', controller: 'test_cases', action: 'create_new_version', as: 'create_new_test_case_version'
  get 'test_cases/copy/:id', controller: 'test_cases', action: 'copy', as: 'copy_test_case'

  # Test Cases - Updated the order, category
  get 'test_cases/new/:category_id', controller: 'test_cases', action: 'new', as: 'new_test_case_with_category'
  get 'test_cases/update_category_select/:id', controller: 'test_cases', action: 'update_category_select'
  # The route below is somewhat dangerous, but is actually a dumby.
  # In order to make the update_category_select jquerywork in the reports form, we make this fake url
  # and then append the id in javascript. This should newver be called directly. Only the line above should be called
  # you must use the :as path for new and edit forms
  get 'test_cases/update_category_select/', controller: 'test_cases', action: 'update_category_select', as: 'jquery_test_case_category_update'

  get 'update_version_select/:id', controller: 'application', action: 'update_version_select'
  # The route below is somewhat dangerous, but is actually a dumby.
  # In order to make the uodate_version_select jquerywork on the results index, we make this fake url
  # and then append the id in javascript. This should newver be called directly. Only the line above should be called
  # you must use the :as path for new and edit forms
  get 'update_version_select/', controller: 'application', action: 'update_version_select', as: 'jquery_application_version_update'

  get 'help', controller: 'help', action: 'index', as: 'help'
  # Guide root to the home module
  root to: 'home#index', as: 'home'
end
