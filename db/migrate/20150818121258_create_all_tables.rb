class CreateAllTables < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :logo
      t.text :content
      t.text :tmp_content
      t.text :script
      t.integer :baseRating
      t.integer :rating
      t.string :system_tag
      t.boolean :to_news, default: false
      t.integer :impressions_count, default: 0
      t.string :state
      t.string :slug

      t.string :tags, array: true

      t.timestamps null: false
    end

    create_table :article_areas do |t|
      t.string :title
    end

    create_table :article_types do |t|
      t.string :title
    end

    create_table :authentications do |t|
      t.string :provider
      t.string :uid
    end

    create_table :comments do |t|
      t.text :content
      t.integer :commentable_id
      t.string  :commentable_type

      t.timestamps null: false
    end

    create_table :cycles do |t|
      t.string :title
      t.text :description
      t.boolean :system, default: false
      t.string :logo
      t.string :slug

      t.string :tags, array: true

      t.timestamps null: false
    end

    create_table :galleries do |t|
      t.string :name
      t.text :description
      t.integer :impressions_count, default: 0
      t.string :slug

      t.string :tags, array: true

      t.timestamps null: false
    end

    create_table :contents do |t|
      t.string :title
      t.string :src
      t.text :description
      t.boolean :approved_to_news, default: false
      t.boolean :reviewed, default: false
      t.integer :impressions_count, default: 0
      t.string :slug

      t.string :tags, array: true

      t.timestamps null: false
    end

    create_table :genders do |t|
      t.string :name
    end

    create_table :images do |t|
      t.attachment :file
    end

    create_table :pictures do |t|
      t.attachment :file
      t.integer :imageable_id
      t.string  :imageable_type
    end

    create_table :projects

    create_table :settings do |t|
      t.boolean :unlock_top_menu, default: false
    end

    create_table :users do |t|
      t.string :name
      t.string :second_name
      t.string :first_name
      t.boolean :subscribed, default: true
      t.integer :comments_count, default: 0
      t.string :from
      t.boolean :is_active, default: true
      t.string :userAvatar
      t.text :about
      t.string :slug

      t.timestamps null: false
    end

    create_table :subscriptions, id: false do |t|
      t.integer :user_id
      t.integer :subscription_id
    end

    add_reference :articles, :user, index: true, foreign_key: true
    add_reference :galleries, :user, index: true, foreign_key: true
    add_reference :cycles, :user, index: true, foreign_key: true
    add_reference :comments, :user, index: true, foreign_key: true
    add_reference :authentications, :user, index: true, foreign_key: true
    add_reference :settings, :user, index: true, foreign_key: true
    add_reference :contents, :user, index: true, foreign_key: true

    add_reference :articles, :article_area, index: true, foreign_key: true
    add_reference :articles, :article_type, index: true, foreign_key: true
    add_reference :articles, :cycle, index: true, foreign_key: true
    add_reference :images, :article, index: true, foreign_key: true

    add_reference :contents, :gallery, index: true, foreign_key: true

    add_reference :users, :gender, index: true, foreign_key: true

    add_index :comments, :commentable_id
    add_index :pictures, :imageable_id
    add_index :articles, :slug
    add_index :users, :slug
    add_index :contents, :slug
    add_index :galleries, :slug
    add_index :cycles, :slug

    add_index :articles, :tags, using: :gin
    add_index :cycles, :tags, using: :gin
    add_index :contents, :tags, using: :gin
    add_index :galleries, :tags, using: :gin

    add_index :articles, :title
    add_index :cycles, :title
    add_index :contents, :title
    add_index :galleries, :name

  end
end
