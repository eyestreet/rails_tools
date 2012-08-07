namespace :rails_tools do
  PRODUCTION_APP = ENV['APP']
  PRODUCTION_BRANCH = ENV['BRANCH'] || 'master'
  PRODUCTION_REMOTE = ENV['REMOTE'] || 'production'
  STAGING_APP = ENV['APP']
  STAGING_BRANCH = ENV['BRANCH'] || 'develop'
  STAGING_REMOTE = ENV['REMOTE'] || 'staging'

  # Deploy and rollback on Heroku in staging and production
  task :staging, [:branch] => [:set_staging_app, :push]
  task :staging_migrations, [:branch] => [:set_staging_app, :push, :migrate]
  task :staging_rollback => [:set_staging_app, :off, :push_previous, :on]

  task :production, [:branch] => [:set_production_app, :push]
  task :production_migrations => [:set_production_app, :push, :migrate]
  task :production_rollback => [:set_production_app, :off, :push_previous, :on]

  task :set_staging_app, [:branch] do |t, args|
    APP = STAGING_APP
    BRANCH = args[:branch] || STAGING_BRANCH
    GIT_REMOTE = STAGING_REMOTE
  end

  task :set_production_app do
    APP = PRODUCTION_APP
    BRANCH = PRODUCTION_BRANCH
    GIT_REMOTE = PRODUCTION_REMOTE
  end

  task :push do
    puts "Deploying branch #{BRANCH} to #{APP} ..."
    log_and_execute "git push -f #{GIT_REMOTE} #{BRANCH}:master"
  end

  task :restart do
    puts 'Restarting app servers ...'
    log_and_execute "heroku restart --app #{APP}"
  end

  task :migrate do
    puts 'Running database migrations ...'
    log_and_execute "heroku run rake db:migrate --app #{APP}"
  end

  task :backup_db do
    puts 'Backing up database ...'
    log_and_execute "heroku pgbackups:capture --expire --app #{APP}"
  end

  task :off do
    puts 'Putting the app into maintenance mode ...'
    log_and_execute "heroku maintenance:on --app #{APP}"
  end

  task :on do
    puts 'Taking the app out of maintenance mode ...'
    log_and_execute "heroku maintenance:off --app #{APP}"
  end

  def log_and_execute(cmd)
    puts cmd
    # puts `#{cmd}`
  end
end