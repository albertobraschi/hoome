# Configure Solidus Preferences
# See http://docs.solidus.io/Spree/AppConfiguration.html for details

Spree.config do |config|
	# Without this preferences are loaded and persisted to the database. This
	# changes them to be stored in memory.
	# This will be the default in a future version.
	config.use_static_preferences!

	# Core:

	# Default currency for new sites
	config.currency = "NOK"

	# from address for transactional emails
	config.mails_from = "martin@stabenfeldt.net"

	# Uncomment to stop tracking inventory levels in the application
	# config.track_inventory_levels = false

	# When set, product caches are only invalidated when they fall below or rise
	# above the inventory_cache_threshold that is set. Default is to invalidate cache on
	# any inventory changes.
	# config.inventory_cache_threshold = 3


	# Frontend:

	# Custom logo for the frontend
	# config.logo = "logo/solidus_logo.png"
  config.logo = "logo/hoome.png"

	# Template to use when rendering layout
	# config.layout = "spree/layouts/spree_application"


	# Admin:

	# Custom logo for the admin
  config.admin_interface_logo = "logo/hoome-small.png"

	# Gateway credentials can be configured statically here and referenced from
	# the admin. They can also be fully configured from the admin.
	#
	# config.static_model_preferences.add(
	#   Spree::Gateway::StripeGateway,
	#   'stripe_env_credentials',
	#   secret_key: ENV['STRIPE_SECRET_KEY'],
	#   publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
	#   server: Rails.env.production? ? 'production' : 'test',
	#   test: !Rails.env.production?
	# )

  @bucket = "#{ENV['S3_BUCKET_NAME']}-#{Rails.env}"

	attachment_config = {

		s3_credentials: {
			access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
			secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
			bucket:            ENV['S3_BUCKET_NAME']
		},

		storage:        :s3,
		s3_headers:     { "Cache-Control" => "max-age=31557600" },
		s3_protocol:    "https",
    bucket:         @bucket,
		url:            ":s3_domain_url",

		styles: {
			mini:     "48x48>",
			small:    "100x100>",
			product:  "240x240>",
			large:    "600x600>"
		},

		path:           "/:class/:id/:style/:basename.:extension",
		default_url:    "/:class/:id/:style/:basename.:extension",
		default_style:  "product"
	}

	attachment_config.each do |key, value|
		Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
	end
end

Spree.user_class = "Spree::LegacyUser"
Spree::Ability.register_ability(Spree::MultiVendorAbility)

