# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150201211104) do

  create_table "assignments", force: :cascade do |t|
    t.text     "notes",        limit: 65535
    t.integer  "product_id",   limit: 4
    t.integer  "version_id",   limit: 4
    t.integer  "test_plan_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "schedule_id",  limit: 4
    t.integer  "stencil_id",   limit: 4
    t.string   "issues",       limit: 255
  end

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "product_id",  limit: 4
    t.integer  "category_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "comment",      limit: 65535
    t.integer  "user_id",      limit: 4
    t.boolean  "deleted",      limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "test_case_id", limit: 4
    t.integer  "test_plan_id", limit: 4
    t.integer  "task_id",      limit: 4
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string   "item_type",       limit: 15
    t.string   "field_name",      limit: 255
    t.string   "field_type",      limit: 15
    t.text     "accepted_values", limit: 65535
    t.boolean  "active",          limit: 1,     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_items", force: :cascade do |t|
    t.integer  "test_case_id",    limit: 4
    t.integer  "test_plan_id",    limit: 4
    t.integer  "custom_field_id", limit: 4
    t.string   "value",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "device_id",       limit: 4
    t.integer  "result_id",       limit: 4
    t.integer  "assignment_id",   limit: 4
  end

  create_table "devices", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.boolean  "active",      limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "histories", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "action",        limit: 1
    t.integer  "test_case_id",  limit: 4
    t.integer  "test_plan_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "result_id",     limit: 4
    t.integer  "assignment_id", limit: 4
    t.integer  "product_id",    limit: 4
    t.integer  "category_id",   limit: 4
    t.integer  "task_id",       limit: 4
    t.integer  "stencil_id",    limit: 4
  end

  create_table "plan_cases", force: :cascade do |t|
    t.integer  "test_case_id", limit: 4
    t.integer  "test_plan_id", limit: 4
    t.integer  "case_order",   limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_users", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.text     "description",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ticket_project_id", limit: 255
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "product_id",        limit: 4
    t.integer  "version_id",        limit: 4
    t.date     "start_date"
    t.date     "end_date"
    t.string   "report_type",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",           limit: 4
    t.integer  "second_version_id", limit: 4
  end

  create_table "result_statistics", force: :cascade do |t|
    t.integer  "result_id",           limit: 4
    t.integer  "test_case_target_id", limit: 4
    t.integer  "mean",                limit: 4
    t.integer  "standard_deviation",  limit: 4
    t.integer  "n",                   limit: 4
    t.integer  "statistic_type",      limit: 2
    t.string   "name",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", force: :cascade do |t|
    t.integer  "assignment_id", limit: 4
    t.integer  "test_case_id",  limit: 4
    t.string   "result",        limit: 255
    t.text     "note",          limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "executed_at"
    t.string   "bugs",          limit: 255
    t.integer  "device_id",     limit: 4
  end

  create_table "schedule_runs", force: :cascade do |t|
    t.integer  "device_id",  limit: 4
    t.datetime "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedule_users", force: :cascade do |t|
    t.integer  "schedule_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer  "device_id",    limit: 4
    t.integer  "product_id",   limit: 4
    t.integer  "test_plan_id", limit: 4
    t.boolean  "monday",       limit: 1
    t.boolean  "tuesday",      limit: 1
    t.boolean  "wednesday",    limit: 1
    t.boolean  "thursday",     limit: 1
    t.boolean  "friday",       limit: 1
    t.boolean  "saturday",     limit: 1
    t.boolean  "sunday",       limit: 1
    t.time     "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "value",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description", limit: 255
  end

  create_table "stencil_test_plans", force: :cascade do |t|
    t.integer  "stencil_id",   limit: 4
    t.integer  "test_plan_id", limit: 4
    t.integer  "device_id",    limit: 4
    t.integer  "plan_order",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stencils", force: :cascade do |t|
    t.integer  "product_id",     limit: 4
    t.string   "name",           limit: 255
    t.text     "description",    limit: 65535
    t.integer  "version",        limit: 2,     default: 1
    t.integer  "status",         limit: 2
    t.boolean  "deprecated",     limit: 1,     default: false
    t.integer  "created_by_id",  limit: 4
    t.integer  "modified_by_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id",      limit: 4
  end

  create_table "steps", force: :cascade do |t|
    t.text     "action",       limit: 65535
    t.text     "result",       limit: 65535
    t.integer  "step_number",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "test_case_id", limit: 4
  end

  create_table "tag_test_cases", id: false, force: :cascade do |t|
    t.integer "tag_id",       limit: 4
    t.integer "test_case_id", limit: 4
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "task",            limit: 4
    t.text     "description",     limit: 65535
    t.date     "due_date"
    t.date     "completion_date"
    t.integer  "status",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",            limit: 255
    t.integer  "assignment_id",   limit: 4
  end

  create_table "test_case_targets", force: :cascade do |t|
    t.string   "filename",     limit: 255
    t.integer  "test_case_id", limit: 4
    t.integer  "content",      limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_cases", force: :cascade do |t|
    t.text     "name",           limit: 65535
    t.text     "description",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "test_type_id",   limit: 4
    t.integer  "category_id",    limit: 4
    t.integer  "product_id",     limit: 4
    t.integer  "status",         limit: 2
    t.integer  "version",        limit: 2,     default: 1
    t.integer  "parent_id",      limit: 4
    t.boolean  "deprecated",     limit: 1,     default: false
    t.integer  "created_by_id",  limit: 4
    t.integer  "modified_by_id", limit: 4
  end

  create_table "test_plans", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.text     "description",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id",     limit: 4
    t.integer  "status",         limit: 2
    t.integer  "version",        limit: 2,     default: 1
    t.integer  "parent_id",      limit: 4
    t.boolean  "deprecated",     limit: 1,     default: false
    t.integer  "created_by_id",  limit: 4
    t.integer  "modified_by_id", limit: 4
  end

  create_table "test_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", force: :cascade do |t|
    t.string   "description",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "upload_file_name",    limit: 255
    t.string   "upload_content_type", limit: 255
    t.integer  "upload_file_size",    limit: 4
    t.datetime "upload_updated_at"
    t.integer  "uploadable_id",       limit: 4
    t.string   "uploadable_type",     limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",            limit: 255
    t.string   "email",               limit: 255
    t.string   "first_name",          limit: 255
    t.string   "last_name",           limit: 255
    t.string   "crypted_password",    limit: 255
    t.string   "password_salt",       limit: 255
    t.string   "persistence_token",   limit: 255
    t.datetime "last_login_at"
    t.string   "current_login_ip",    limit: 255
    t.string   "last_login_ip",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                limit: 1
    t.boolean  "active",              limit: 1
    t.string   "time_zone",           limit: 255
    t.integer  "failed_login_count",  limit: 1
    t.string   "single_access_token", limit: 255
    t.datetime "last_request_at"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "version",           limit: 255
    t.text     "description",       limit: 65535
    t.integer  "product_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ticket_version_id", limit: 4
  end

end
