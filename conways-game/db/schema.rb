# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_03_161559) do
  create_table "boards", force: :cascade do |t|
    t.integer "size"
    t.integer "attempts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cells", force: :cascade do |t|
    t.integer "board_id", null: false
    t.integer "main_cell_id"
    t.boolean "alive"
    t.integer "x_position"
    t.integer "y_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_cells_on_board_id"
    t.index ["main_cell_id"], name: "index_cells_on_main_cell_id"
  end

  add_foreign_key "cells", "boards"
  add_foreign_key "cells", "cells", column: "main_cell_id"
end
