image:
	docker build -t lambda-ruby2.5-postgresql10 .

shell:
	docker run --rm -it -v $$PWD:/var/task -w /var/task lambda-ruby2.5-postgresql10

install:
	docker run --rm -it -v $$PWD:/var/task -w /var/task lambda-ruby2.5-postgresql10 make _install

test:
	docker run --rm -it -v $$PWD:/var/task -w /var/task lambda-ruby2.5-postgresql10 make _test

zip:
	rm -f deploy.zip
	zip -q -r deploy.zip . -x .git/\*

clean:
	rm -rf .bundle/
	rm -rf vendor/
	rm -rf lib/

deploy:
	aws lambda create-function \
			--region ap-southeast-2 \
			--function-name RubyLambdaPostgreSQLNokogiri \
			--zip-file fileb://deploy.zip \
			--runtime ruby2.5 \
			--role arn:aws:iam::000000000000:role/lambda-execution-role \
			--timeout 20 \
			--handler handler.main

update:
	aws lambda update-function-code \
			--region ap-southeast-2 \
			--function-name RubyLambdaPostgreSQLNokogiri \
			--zip-file fileb://deploy.zip

delete:
	aws lambda delete-function \
			--region ap-southeast-2 \
			--function-name RubyLambdaPostgreSQLNokogiri

invoke:
	aws lambda invoke \
		--region ap-southeast-2 \
		--function-name RubyLambdaPostgreSQLNokogiri /dev/stdout

# Commands that start with underscore are run *inside* the container.

_install:
	bundle config --local build.pg --with-pg-config=/usr/pgsql-10/bin/pg_config
	bundle config --local silence_root_warning true
	bundle install --path vendor/bundle --clean
	mkdir -p /var/task/lib
	cp -a /usr/pgsql-10/lib/*.so.* /var/task/lib/

_test:
	ruby -e "require 'handler'; puts main(event: nil, context: nil)"
