
build:
	docker build . -t pago-uploads:latest
run:
	docker run -p 9292:9292 -it pago-uploads:latest bundle exec thin start -R config.ru -a 0.0.0.0 -p 9292
test:
	docker run -it pago-uploads:latest bundle exec rspec
lint:
	docker run -it pago-uploads:latest bundle exec rubocop -A