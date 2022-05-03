# README

* System dependencies

`docker-compose run api bundle`

* Database creation initialization

`docker-compose run api bin/rails db:create db:migrate`

`docker-compose run -e "RAILS_ENV=test" api rails db:create db:migrate`

* How to run the test suite

`docker-compose run api rspec`

* Test logic in console

`docker-compose up -d`

`docker-compose exec api bin/rails c`

* explaining any decisions you made:

user has one wallet(could be extend to more)

user has transactions(used to track all kind of transactions for wallets)

Use a `WalletService` to handle wallet transactions(deposit, withdraw, transfer)

Use `ActiveRecord::Base.transaction` to perform RDS transaction and add `lock_version` for optimistic locking to make sure data accuracy

* how should reviewer view your code:

Check on `app/services/wallet_service.rb` for the implementation for transactions.

Check on `spec/services/wallet_service_spec.rb` for test cases.

areas to be improved:

It could be restructured to submodule or gem.

how long you spent on the test:

~2 hours

