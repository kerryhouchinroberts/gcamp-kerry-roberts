# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :cleanup => :environment do

  Membership.select {|membership| membership.user == nil}.each {|m| m.delete}

  Membership.select {|membership| membership.project == nil}.each {|m| m.delete}
  Task.select {|task| task.project == nil}.each {|m| m.delete}
  Comment.select {|comment| comment.task == nil}.each {|m| m.delete}

  comments = Comment.select {|comment| comment.user == nil }
  comments.map do |comment|
    comment.user_id = nil
    comment.save
  end
end
