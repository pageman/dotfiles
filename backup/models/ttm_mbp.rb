# encoding: utf-8

##
# Backup Generated: ttm_mbp
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t ttm_mbp [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://meskyanichi.github.io/backup
#
Model.new(:ttm_mbp, 'the mbp I use at ttm') do
  ##
  # Archive [Archive]
  #
  # Adding a file or directory (including sub-directories):
  #   archive.add "/path/to/a/file.rb"
  #   archive.add "/path/to/a/directory/"
  #
  # Excluding a file or directory (including sub-directories):
  #   archive.exclude "/path/to/an/excluded_file.rb"
  #   archive.exclude "/path/to/an/excluded_directory
  #
  # By default, relative paths will be relative to the directory
  # where `backup perform` is executed, and they will be expanded
  # to the root of the filesystem when added to the archive.
  #
  # If a `root` path is set, relative paths will be relative to the
  # given `root` path and will not be expanded when added to the archive.
  #
  #   archive.root '/path/to/archive/root'
  #
  archive :my_archive do |archive|
    # Run the `tar` command using `sudo`
    # archive.use_sudo
    # archive.add "/path/to/a/file.rb"
    archive.add File.expand_path("~/Dropbox/")
    archive.add File.expand_path("~/var/")
    # archive.exclude "/path/to/a/excluded_file.rb"
    # archive.exclude "/path/to/a/excluded_folder"
  end


  ##
  # Amazon Simple Storage Service [Storage]
  #
  store_with S3 do |s3|
    # AWS Credentials
    key_id = File.read(File.expand_path "~/var/secrets/aws_access_key_id").strip
    secret = File.read(File.expand_path "~/var/secrets/aws_secret_key").strip
    puts "AWS: #{key_id}, #{secret}"
    s3.access_key_id     = key_id
    s3.secret_access_key = secret
    # Or, to use a IAM Profile:
    # s3.use_iam_profile = true

    s3.region            = "us-east-1"
    s3.bucket            = "jnm-private"
    s3.path              = "backups"
  end

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path       = "~/backups/"
    local.keep       = 2
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #
  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = "mccracken.joel+automated@gmail.com"
    mail.to                   = "mccracken.joel@gmail.com"
    mail.address              = "smtp.gmail.com"
    mail.port                 = 587
    mail.domain               = "smtp.gmail.com"
    mail.user_name            = "mccracken.joel@gmail.com"
    mail.password             = File.read(File.expand_path "~/var/secrets/gmail_password")
    mail.authentication       = "plain"
    mail.encryption           = :starttls
  end

end
