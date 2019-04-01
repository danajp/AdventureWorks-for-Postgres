DATA_URL?=https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks-oltp-install-script.zip
ZIP_FILE?=AdventureWorks-oltp-install-script.zip
DBNAME?=adventureworks
CLUSTER_URL?=postgres://postgres:postgres@localhost
DATABASE_URL?=$(CLUSTER_URL)/$(DBNAME)

.PHONY: build
build: data
	psql "$(CLUSTER_URL)" -c "CREATE DATABASE $(DBNAME);"
	cd data && psql "$(DATABASE_URL)" < ../install.sql

.PHONY: connect
connect:
	psql "$(DATABASE_URL)"

.PHONY: clean
clean:
	psql "$(CLUSTER_URL)" -c "DROP DATABASE IF EXISTS $(DBNAME);"
	rm -rf data

data:
	mkdir -p data
	unzip -d data "$(ZIP_FILE)"
	cd data && ruby ../update_csvs.rb

$(ZIP_FILE):
	wget -qO "$@" "$(DATA_URL)"
