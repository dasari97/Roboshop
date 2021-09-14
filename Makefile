

help: ## Choose component to install
	@fgrep -h "##" $(MAKEFILE_LIST) | grep -v fgrep

catalogue:	
## catalogue
	@bash components/catalogue.sh

mongodb:	
## mongodb
	@bash components/mongodb.sh

redis:	
## redis
	@bash components/redis.sh

cart:	
## cart
	@bash components/cart.sh

mysql:	
## mysql
	@bash components/mysql.sh

shipping:	
## shipping
	@bash components/shipping.sh

payment:	
## payment
	@bash components/payment.sh

frontend:	
## frontend
	@bash components/frontend.sh
	
user:	
##user
	@bash components/user.sh
	
rabbitmq:
##rabbitmq
	@bash components/rabbit.sh