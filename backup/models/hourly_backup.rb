##
# Backup Generated: hourly_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t hourly_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:hourly_backup, 'Description for hourly_backup') do
  database PostgreSQL do |db|
    db.name      = 'homebus_' + ENV['RAILS_ENV']
    db.username  = ENV['POSTGRESQL_USERNAME']
    db.password  = ENV['POSTGRESQL_PASSWORD']
    db.host      = ENV['POSTGRESQL_HOSTNAME']
    db.port      = ENV['POSTGRESQL_PORT']
  end

  compress_with Bzip2

  compress_with Bzip2 do |compression|
    compression.level = 9
  end

  store_with S3 do |s3|
    s3.bucket = ENV['AWS_S3_BUCKET']
    s3.path   = "#{Socket.gethostname}/#{ENV['AWS_S3_PATH']}"

    s3.keep   = 5
  end
end
