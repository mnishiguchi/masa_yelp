LOCATIONS = %w[
  alexandria-va
  annandale-va
  arlington-va
  ashburn-va
  bethesda-md
  burke-va
  centreville-va
  chantilly-va
  clifton-va
  frederick-md
  gaithersburg-md
  manassas-va
  mclean-va
  merrifield-va
  reston-va
  rockville-md
  silver-spring-md
  springfield-va
  sterling-va
  tysons-va
  washington-dc
  woodbridge-va
].freeze

namespace :yelp do
  desc "Import yelp and save to a single file in db/feeds/[timestamp] dir"
  task import: :environment do
    import_to_single_file
  end
end

private

def import_to_single_file(locations = LOCATIONS)
  businesses = []
  locations.each do |location|
    %w[restaurant asian korean japanese thai vietnamese].each do |term|
      businesses += fetch_businesses(location: location, term: term, offset: 0)
      businesses += fetch_businesses(location: location, term: term, offset: 50)
      businesses += fetch_businesses(location: location, term: term, offset: 100)
    end
  end
  businesses.uniq! { |business| business[:id] }

  output_file = "#{output_dir}/businesses.yaml"
  File.write(output_file, businesses.to_yaml)
  puts
  puts "#{businesses.size} businesses saved to #{output_file}"
  puts
end

# def import_to_multiple_files(locations = LOCATIONS)
#   locations.each do |location|
#     businesses = []
#     businesses += fetch_businesses(location: location, offset: 0)
#     businesses += fetch_businesses(location: location, offset: 50)
#
#     output_file = "#{output_dir}/#{location}.yaml"
#     File.write(output_file, businesses.to_yaml)
#     puts
#     puts "#{businesses.size} businesses saved to #{output_file}"
#     puts
#   end
# end

def fetch_businesses(location:, offset: 0, term: "restaurants")
  # https://www.yelp.com/developers/documentation/v3/business_search
  params = { location: location,
             offset: offset,
             term: term,
             radius: 40_000,
             limit: 50,
             price: "1,2,3" }
  Yelp::Request.new("businesses", params).response[:businesses]
end

def output_dir
  output_dir = Rails.root.join("db/feeds/#{Time.current.strftime('%Y%m%d')}").to_s
  mkdir_p(output_dir)
  output_dir
end
