S3_BUCKET ?= "tf.isaaguilar.com"


clean:
	rm -rf public
build: clean
	hugo
s3-deploy: build
	aws s3 sync public/ s3://${S3_BUCKET} --profile ${AWS_PROFILE}

# Personally, right now deploy is always s3
deploy: s3-deploy

.phony: clean build s3-deploy deploy
