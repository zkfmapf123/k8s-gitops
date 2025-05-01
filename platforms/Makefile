up-user:
	cd service-user && helm upgrade --install user . -n service

up-payment:
	cd service-payment && helm upgrade --install payment . -n service

up:
	make up-user
	make up-payment

down:
	cd service-user && helm uninstall user -n service
	cd service-payment && helm uninstall payment -n service