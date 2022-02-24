.PHONY: build
.ONESHELL:

# mfa:
# 	@ alias aws='docker run -i --rm -e AWS_PROFILE=$${AWS_PROFILE} -v ~/.aws/:/root/.aws/ amazon/aws-cli'
# 	aws s3 ls > /dev/null

build:
	@ $(if $(AWS_PROFILE),$(call assume_role))
	alias packer='docker run --rm -e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins -v `pwd`:/workspace -w /workspace  hashicorp/packer:latest'
	packer init . && packer fmt . && packer validate . && \
	docker run --rm -v `pwd`:/workspace -w /workspace \
		-e HTTPS_PROXY=http://192.168.0.133:33338 \
		-e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
		-e PKR_VAR_aws_access_key_id=$${AWS_ACCESS_KEY_ID} \
		-e PKR_VAR_aws_secret_access_key=$${AWS_SECRET_ACCESS_KEY} \
		-e PKR_VAR_aws_session_token=$${AWS_SESSION_TOKEN} \
		hashicorp/packer:latest build ecsctm.pkr.hcl	

# Dynamically assumes role and injects credentials into environment
define assume_role
	alias aws='docker run -i --rm -e HTTPS_PROXY=http://192.168.0.133:33338 -e AWS_PROFILE=$${AWS_PROFILE} -v ~/.aws/:/root/.aws/ amazon/aws-cli'

	export AWS_DEFAULT_REGION=$$(aws configure get region)
	export ROLE_ARN=$$(aws configure get role_arn)
	export ROLE_SESSION_NAME=$$(aws configure get role_session_name)

	eval $$(aws sts assume-role --role-arn=$${ROLE_ARN} \
		--role-session-name=$${ROLE_SESSION_NAME} \
		--query "Credentials.[ \
			[join('=',['export AWS_ACCESS_KEY_ID',AccessKeyId])], \
			[join('=',['export AWS_SECRET_ACCESS_KEY',SecretAccessKey])], \
			[join('=',['export AWS_SESSION_TOKEN',SessionToken])] \
		]" \
		--output text)

endef

