test:
	timeout 5 ./test.sh

clean:
	rm test-pipe

lint:
	bundle exec rubocop
