NAME = inception

SRCS = ./srcs/docker-compose.yml

all: 
	@mkdir -p /home/$(USER)/data/mariadb
	@mkdir -p /home/$(USER)/data/wordpress
	@docker compose -f $(SRCS) up -d --build

down:
	@docker compose -f $(SRCS) down

clean:
	@docker compose -f $(SRCS) down --rmi all -v

fclean : clean
	@docker system prune -af
	@sudo rm -rf /home/$(USER)/data/mariadb/*
	@sudo rm -rf /home/$(USER)/data/wordpress/*

re : fclean all

.PHONY: all down clean fclean re