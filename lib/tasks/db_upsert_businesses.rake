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

# Create or update a record.
def upsert_business_record(yelp_business)
  params = build_params(yelp_business)
  business = Business.find_or_initialize_by(yelp_uid: yelp_business[:id])
  business.update_attributes(params)
end

# Build params from yelp hash.
def build_params(yelp_business)
  yelp_business.
    slice(:name, :image_url, :rating, :phone, :display_phone).
    merge(yelp_business[:location]).
    merge(yelp_business[:coordinates]).
    merge(
      yelp_uid: yelp_business[:id],
      url: yelp_business[:url].split(/\?/).first,
      price: yelp_business[:price].length,
      categories: join_categories(yelp_business[:categories]),
      display_address: yelp_business.dig(:location, :display_address)
    )
end

# Join all the category strings into a comma-separated string.
def join_categories(categories)
  categories.reduce([]) { |union, category| union | category.values.map(&:downcase) }.join(",")
end
