namespace :db do
  desc "Upsert businesses from a yaml file"
  task :upsert_businesses, [:file_path] => [:environment] do |_t, args|
    raise ArgumentError.new, "Usage: rake feed:upsert_businesses[file_path]" if args[:file_path].blank?

    input_file = Rails.root.join(args[:file_path])
    yelp_businesses = YAML.load_file(input_file)

    ActiveRecord::Base.transaction do
      yelp_businesses.map do |yelp_business|
        upsert_business_record(yelp_business)
        print "."
      end
    end
  end
end

private

def upsert_business_record(yelp_business)
  yelp_uid = yelp_business[:id]

  # Build params from yelp hash.
  attrs = %i[name image_url categories rating price phone display_phone coordinates location]
  params = yelp_business.slice(*attrs).merge(yelp_uid: yelp_uid, url: yelp_business[:url].split(/\?/).first)

  # Create or update a record.
  business = Business.find_or_initialize_by(yelp_uid: yelp_uid)
  business.update_attributes(params)
end
