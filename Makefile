bundle_folder ?= "bundles"

# Create lambda hander function bundles
bundle::
	mkdir -p $(bundle_folder)
	zip -rj $(bundle_folder)/creator.zip functions/creator
	zip -rj $(bundle_folder)/resolver.zip functions/resolver
