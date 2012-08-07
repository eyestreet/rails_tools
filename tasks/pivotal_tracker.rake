namespace :rails_tools do
  desc "Given at least one commit hash or tag prints the Pivotal Tracker story titles and owners from all the stories referenced in the commits contained within"
  task :changelog, [:from, :to] => :environment do |t, args|
    from = args[:from]
    to   = args[:to]

    if from.blank?
      abort "Must specify at least a starting hash or tag.\n\n\trake rails_tools:changelog[tag1,tag2]"
    end

    PivotalTracker::Client.token = ENV['PT_CLIENT_TOKEN'] #v'c0c1cd5788c9f53f2d5ae31b1506f7ac' # staff@eyestreetresearch.com
    project_id = ENV['PROJECT_ID'] # 239055
    project = PivotalTracker::Project.find(project_id)

    commits = `git log #{from}..#{to} --no-merges --pretty=format:'%s'`.split("\n")

    ids = []
    commits.each do |commit|
      ids = ids + commit.scan(/#(\d{8,})/).flatten
    end

    issues = {}
    ids.uniq.each do |id|
      if story = project.stories.find(id)
        story_type = story.story_type
        story_line = [id, story.name, story.owned_by]
        issues[story_type] ||= []
        issues[story_type] << story_line
      else
        puts "Story #{id} not found"
      end
    end

    puts
    str = "Change log for #{`git symbolic-ref -q HEAD`} from #{from}"
    str << (to.present? ? " to #{to}" : " and on")

    puts str
    issues.keys.sort.each do |type|
      puts
      puts type.capitalize.pluralize << ":"
      issues[type].each { |l| puts l.join(' - ')}
    end
  end
end