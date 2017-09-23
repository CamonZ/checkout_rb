require 'active_record'
require 'yaml'

# Partially lifted from activerecord's railties
db_namespace = namespace :db do

  task :load_config do
    @config  = YAML::load(File.open('config/database.yml'))['default']
    @migration_paths = Dir.glob('db/migrate/')
  end

  task create: [:load_config] do
    ActiveRecord::Tasks::DatabaseTasks.create(@config)
  end

  task drop: [:load_config] do
    ActiveRecord::Tasks::DatabaseTasks.drop(@config)
  end

  task migrate: [:load_config] do
    ActiveRecord::Base.establish_connection(@config) #establish db connection
    ActiveRecord::Migrator.migrate(@migration_paths)
    db_namespace["schema:dump"].invoke
  end

  task :reset => [:drop, :create, :migrate]

  namespace :schema do
    task :dump do
      require 'active_record/schema_dumper'

      filename = "db/schema.rb"

      File.open(filename, "w:utf-8") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end
end

namespace :g do
  task :migration do
    name = ARGV[1] || raise("Specify name: rake g:migration your_migration")

    path = migration_path(name)

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class(name)} < ActiveRecord::Migration[5.1]
  def up
  end

  def down
  end
end
EOF
    end

    puts "Migration #{name} created on #{path}"

    abort # Added so rake doesn't attempt to run name as a task
  end

  def timestamp
    Time.now.strftime("%Y%m%d%H%M%S")
  end

  def migration_path(name)
    File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
  end

  def migration_class(name)
    name.split("_").map(&:capitalize).join
  end
end
