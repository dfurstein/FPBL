desc 'Lock all auction posts that have not been updated in the last day'

namespace :update do
  task auction: :environment do
    Forem::Topic.where(forum_id: 9, locked: 0).where('last_post_at <= ?', 1.day.ago).update_all(locked: 1)
  end
end
