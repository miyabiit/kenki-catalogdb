# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_16_065401) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "company_id", null: false
    t.string "name", null: false
    t.integer "position"
    t.boolean "last", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_categories_on_category_id"
    t.index ["company_id"], name: "index_categories_on_company_id"
  end

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "uid", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "product_sub_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "sub_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id", "sub_category_id"], name: "index_product_sub_categories_on_product_id_and_sub_category_id", unique: true
    t.index ["product_id"], name: "index_product_sub_categories_on_product_id"
    t.index ["sub_category_id"], name: "index_product_sub_categories_on_sub_category_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "product_code", null: false
    t.string "title", null: false
    t.boolean "netis", default: false
    t.date "netis_limit_date"
    t.boolean "qualification_sp_teach", default: false
    t.boolean "qualification_skill", default: false
    t.text "qualification_comment"
    t.boolean "driver_license", default: false
    t.boolean "checking_teiji", default: false
    t.boolean "checking_tokujiken", default: false
    t.boolean "checking_shaken", default: false
    t.boolean "checking_denhou", default: false
    t.boolean "checking_souken", default: false
    t.text "description_a"
    t.text "description_b"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_code"], name: "index_products_on_product_code", unique: true
  end

  create_table "stored_prop_sub_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "stored_prop_id", null: false
    t.bigint "sub_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stored_prop_id", "sub_category_id"], name: "idx_uniq_stored_prop_sub_categories", unique: true
    t.index ["stored_prop_id"], name: "index_stored_prop_sub_categories_on_stored_prop_id"
    t.index ["sub_category_id"], name: "index_stored_prop_sub_categories_on_sub_category_id"
  end

  create_table "stored_props", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type", default: "TextProp"
    t.text "text_content"
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_stored_props_on_company_id"
  end

  create_table "sub_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_sub_categories_on_company_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type", null: false
    t.string "login_name", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.bigint "company_id"
    t.string "staff_role", default: "read"
    t.string "name"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["login_name"], name: "index_users_on_login_name", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "companies"
  add_foreign_key "product_sub_categories", "products"
  add_foreign_key "product_sub_categories", "sub_categories"
  add_foreign_key "stored_prop_sub_categories", "stored_props"
  add_foreign_key "stored_prop_sub_categories", "sub_categories"
  add_foreign_key "users", "companies"
end
