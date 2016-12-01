.PHONY : create update events watch output delete validate
STACK:=cloudformation-cd
AWS_REGION:=eu-west-1
AWS_PROFILE:=codedoor

create: validate
	aws cloudformation create-stack --stack-name $(STACK) --template-body file://`pwd`/$(STACK).yml --parameters file://`pwd`/.env --capabilities CAPABILITY_IAM --profile $(AWS_PROFILE) --region $(AWS_REGION)

update: validate
	aws cloudformation update-stack --stack-name $(STACK) --template-body file://`pwd`/$(STACK).yml --parameters file://`pwd`/.env --capabilities CAPABILITY_IAM --profile $(AWS_PROFILE) --region $(AWS_REGION)

changeset: validate
	aws cloudformation create-change-set --stack-name $(STACK) --template-body file://`pwd`/$(STACK).yml --parameters file://`pwd`/.env --capabilities CAPABILITY_IAM --profile $(AWS_PROFILE) --region $(AWS_REGION)

describe-changeset:
	aws describe-change-set --change-set-name $(CHANGESET-NAME)

events:
	aws cloudformation describe-stack-events --stack-name $(STACK) --profile $(AWS_PROFILE) --region $(AWS_REGION)

watch:
	while :; do clear; make events | head -25; sleep 5; done

output:
	@which jq || ( which brew && brew install jq || which apt-get && apt-get install jq || which yum && yum install jq || which choco && choco install jq)
	aws cloudformation describe-stacks --stack-name $(STACK) --profile $(AWS_PROFILE) --region $(AWS_REGION) | jq -r '.Stacks[].Outputs'

delete:
	aws cloudformation delete-stack --stack-name $(STACK) --profile $(AWS_PROFILE) --region $(AWS_REGION)

validate:
	@which aws || pip install awscli
	aws cloudformation validate-template --template-body file://`pwd`/$(STACK).json

test-syntax:
	make --just-print