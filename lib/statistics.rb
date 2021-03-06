class Statistics
  class << self
    def daily_repository_counts
      repos = Repository.
                select(['date(created_at) AS created_at_date', 'count(created_at) AS repository_count']).
                where('last_build_id IS NOT NULL').
                group('created_at_date').
                order('created_at_date')

      repo_totals = 0

      repos.map do |r|
        {
          :date => r.created_at_date,
          :added_on_date => r.repository_count.to_i,
          :total_growth => repo_totals += r.repository_count.to_i
        }
      end
    end

    def daily_tests_counts
      tests = Job.
                select(['date(created_at) AS created_at_date', 'count(created_at) AS test_count']).
                group('created_at_date').
                order('created_at_date').
                where(['created_at > ?', 28.days.ago]).
                where(['type = ?', 'Job::Test'])

      tests.map do |b|
        {
          :date => b.created_at_date,
          :run_on_date => b.test_count.to_i,
        }
      end
    end
  end
end
