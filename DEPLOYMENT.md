# Lightweight Activities Rails Portal Plugin Deployment

## Updating the rails portal with your latest plugin changes
Updating the rails portal is very similar to updating the dummy app.

1. Bump the plugin version in lib/lightweight/version.rb
2. Make sure you've committed and pushed any changes (including the version bump) in the plugin to Github
2. In the rails portal codebase, make sure you're on the lightweight-mw branch:

        git checkout lightweight-mw

3. Update the plugin, and make sure that Gemfile.lock shows the newly bumped version:

        bundle update lightweight_activities
        cat Gemfile.lock | grep lightweight

3. Now update the assets

        bundle exec rake assets:precompile

4. Install any new migrations

        bundle exec rake lightweight:install:migrations

5. Commit and push the changes
6. Deploy the branch to the server

        bundle exec cap lightweight-mw deploy deploy:migrate
