# frozen_string_literal: true

##
# Backup v5.x Configuration
#
# Documentation: http://backup.github.io/backup
# Issue Tracker: https://github.com/backup/backup/issues

require 'dotenv'

Dotenv.load(File.expand_path('~/HomeBus/shared/.env'))

tmp_path  File.expand_path('~/HomeBus/shared/tmp')

data_path File.expand_path('~/HomeBus/shared/backups')

# lock down where we find these programs
Utilities.configure do
  tar        '/bin/tar'
  cat        '/bin/cat'
  split      '/usr/bin/split'
  chown      '/bin/chown'
  gzip       '/bin/gzip'
  bzip2      '/bin/bzip2'
  pg_dump    '/usr/bin/pg_dump'
  pg_dumpall '/usr/bin/pg_dumpall'
end

Logger.configure do
  logfile.enabled   = true
  logfile.log_path  = File.expand_path('~/HomeBus/shared/log')
  logfile.max_bytes = 500_000
end

Storage::S3.defaults do |s3|
  s3.access_key_id     = ENV['AWS_S3_ACCESS_KEY_ID']
  s3.secret_access_key = ENV['AWS_S3_SECRET_ACCESS_KEY']
  s3.region            = ENV['AWS_REGION']
end
