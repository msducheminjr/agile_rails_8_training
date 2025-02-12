class ConvertProductDescriptionToRichText < ActiveRecord::Migration[8.0]
  def up
    attribute = :description
    klass = Product

    total_updated = 0
    say_with_time("Migrated #{klass.table_name}") do
      # would retrieve records in batches to minimize memory usage if there were more
      Product.all.each do |record|
        body = ActionText::Content.new(record.description)

        ActiveRecord::Base.no_touching do
          rich_text = ActionText::RichText.new(body: body,
                                               name: attribute.to_s,
                                               record_type: klass.to_s,
                                               record_id: record.id,
                                               created_at: record.created_at,
                                               updated_at: record.updated_at)
          rich_text.save!
          puts "rich_text is #{rich_text}"
          puts "rich_text body HTML is #{rich_text.body.to_html}"
        end

        total_updated += 1
      end
      total_updated
    end
    # rename column so we can restore it after playtime
    rename_column :products, :description, :description_before_action_text
  end


  def down
    # destroy product description rich texts
    ActionText::RichText.where(record_type: "Product", name: "description").destroy_all
    # rename column back after playtime
    rename_column :products, :description_before_action_text, :description
  end
end
