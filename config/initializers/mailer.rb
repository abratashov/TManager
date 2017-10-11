config = YAML.load_file(Rails.root.join('config/mailer.yml').to_s)[Rails.env]

ActionMailer::Base.delivery_method = :smtp unless Rails.env == 'test'
ActionMailer::Base.smtp_settings = {
  address:              config['address'],
  port:                 config['port'],
  domain:               config['domain'],
  user_name:            config['user_name'],
  password:             config['password'],
  authentication:       config['authentication'],
  enable_starttls_auto: config['enable_starttls_auto'],
  openssl_verify_mode:  'none'
}
