web: 					bundle exec rails server thin -p $PORT
worker: 			bundle exec rake resque:work QUEUE=critical,high,medium,low
scheduler: 		bundle exec rake resque:scheduler