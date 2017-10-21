# https://github.com/guard/guard#readme

## Only include directories you want to watch
directories %w[app lib config spec]. \
  select { |d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist") }

# Note: The cmd option is now required due to the increasing number of ways
#       rspec may be run, below are examples of the most common uses.
#  * bundler: 'bundle exec rspec'
#  * bundler binstubs: 'bin/rspec'
#  * spring: 'bin/rspec' (This will use spring if running and you have
#                          installed the spring binstubs per the docs)
#  * zeus: 'zeus rspec' (requires the server to be started separately)
#  * 'just' rspec: 'rspec'

require "active_support/inflector"

guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails(view_extensions: %w[erb haml slim])
  dsl.watch_spec_files_for(rails.app_files)
  dsl.watch_spec_files_for(rails.views)

  watch(rails.controllers) do |m|
    [
      *Dir.glob("spec/requests/**/#{m[1]}_spec.rb"),
      *Dir.glob("spec/controllers/**/#{m[1]}_controller_spec.rb")
    ]
  end

  # Rails config changes
  watch(rails.spec_helper)    { rspec.spec_dir }
  watch(rails.routes)         { ["#{rspec.spec_dir}/controllers", "#{rspec.spec_dir}/requests"] }
  watch(rails.app_controller) { ["#{rspec.spec_dir}/controllers", "#{rspec.spec_dir}/requests"] }
  watch(%r{^spec/factories/(.+)\.rb$}) do |m|
    [
      *Dir.glob("spec/models/**/#{m[1].singularize}_spec.rb"),
      *Dir.glob("spec/requests/**/#{m[1]}_spec.rb"),
      *Dir.glob("spec/controllers/**/#{m[1]}_controller_spec.rb")
    ]
  end

  # # Capybara features specs
  # watch(rails.view_dirs)     { |m| rspec.spec.call("features/#{m[1]}") }
  # watch(rails.layouts)       { |m| rspec.spec.call("features/#{m[1]}") }
end
