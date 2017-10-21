require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
end

RSpec.configure do |c|
  c.around(:each, :vcr) do |example|
    # Taking dirs after "spec" as cassete path inside "cassettes" folder:
    file_path_entries = example.metadata[:file_path].split(File::SEPARATOR)
    raise "File path must contain \"spec\" directory" unless file_path_entries.include?("spec")

    cassetes_dir = file_path_entries.drop(file_path_entries.index("spec") + 1)[0...-1]
    raise "Specs should not be placed to \"spec\" directory directly" if file_path_entries.empty?

    # Use spec file name without "_spec" suffix and extension as cassette name:
    cassetes_dir << File.basename(example.metadata[:file_path], ".rb").sub("_spec", "")
    name = File.join(*cassetes_dir)

    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end
end
