bundle_folder ?= "bundles"
terraform_folder ?= "terraform"


# Create lambda hander function bundles
bundle::
	mkdir -p $(bundle_folder)
	zip -rj $(bundle_folder)/creator.zip functions/creator
	zip -rj $(bundle_folder)/resolver.zip functions/resolver

# Run terraform plan command
plan::
	@cd $(terraform_folder) && terraform plan

# Run terraform apply command
apply::
	@cd $(terraform_folder) && terraform apply

# Initialize the terraform and the Nodejs projects
init::
	@npm install
	@cd $(terraform_folder) && terraform init
