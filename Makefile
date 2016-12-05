.PHONY : create update events watch output delete validate
STACKS = vpc s3 wordpress
STACK:=cloudformation-cd
AWS_REGION:=eu-west-1
AWS_PROFILE:=codedoor
STACK_FOLDER:=stacks
CHANGE_SET_NAME:=$(STACK)-$(CIRCLE_SHA1)
PR_TITLE=Push ot production\n

create: validate
	aws cloudformation create-stack --stack-name $(STACK) --template-body file://`pwd`/$(STACK_FOLDER)/$(STACK).yml --parameters file://`pwd`/.env --capabilities CAPABILITY_IAM --profile $(AWS_PROFILE) --region $(AWS_REGION)

update: validate
	aws cloudformation update-stack --stack-name $(STACK) --template-body file://`pwd`/$(STACK_FOLDER)/$(STACK).yml --parameters file://`pwd`/.env --capabilities CAPABILITY_IAM --profile $(AWS_PROFILE) --region $(AWS_REGION)

create-changeset: validate
	aws cloudformation create-change-set --change-set-name $(CHANGE_SET_NAME) --stack-name $(STACK) --template-body file://`pwd`/$(STACK_FOLDER)/$(STACK).yml --parameters file://`pwd`/.env --capabilities CAPABILITY_IAM --profile $(AWS_PROFILE) --region $(AWS_REGION)

describe-changeset:
	aws cloudformation describe-change-set --change-set-name $(CHANGE_SET_NAME) --stack-name $(STACK) --profile $(AWS_PROFILE) --region $(AWS_REGION)

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
	aws cloudformation validate-template --template-body file://`pwd`/$(STACK_FOLDER)/$(STACK).yml

pr:
	@which hub || ( which brew && brew install hub || curl https://hub.github.com/standalone -Lo /usr/bin/hub && chmod 755 /usr/bin/hub)
	@which jq || ( which brew && brew install jq || which apt-get && apt-get install jq || which yum && yum install jq || which choco && choco install jq)
  make describe-changeset | jq -r '.Stacks[].Outputs' | hub pull-request -m $(PR_TITLE)$(PR_MESSAGE) -b production -h master -F # check if PR is already open

test-syntax:
	make --just-print