# Architecting GraphQL apps workshop

## Getting started

We will work with your Heroku app, if you haven't created a Heroku app already then you can deploy using:

[![Deploy to
Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/hasura/graphql-engine-heroku)

![Create New App - Heroku](https://graphql-engine-cdn.hasura.io/heroku-repo/assets/create_new_app_heroku_3.png)

#### Add admin secret

1. From the Heroku app dashboard (`dashboard.heroku.com/apps/<my-app-name>`), navigate to the Settings tab -> Reveal config vars. 

2. Add a new config var:  `HASURA_GRAPHQL_ADMIN_SECRET: adminsecret` 


#### For local Docker setup

In case you prefer to work locally with docker containers instead:

Use `docker-compose up -d`

View your new Hasura GraphQL Engine Console at [http://localhost:8080](http://localhost:8080) (admin secret from docker-compose.yaml: `adminsecret`)

*Note*: To end a session, use `docker-compose down -v`


## Loading initial data

#### Via console
- Head to the Data tab and go to the Run SQL window
- Run schema.sql
- Run data.sql

#### For a Heroku deployment

From the Heroku app dashboard (`dashboard.heroku.com/apps/<my-app-name>`), navigate to the Settings tab -> Reveal config vars -> DATABASE_URL. Use the following command:

```
psql <DATABASE_URL> < schema.sql
psql <DATABASE_URL> < data.sql

```

or, lacking psql, use the following with the [heroku CLI](https://devcenter.heroku.com/articles/heroku-cli): (might need to run `heroku login` first):

```
heroku pg:psql -a <my-app-name> < schema.sql
heroku pg:psql -a <my-app-name> < data.sql

```

#### For local Docker setup

Use the following command to set up initial tables and data into your postgres container:

```
psql postgres://postgres:mypassword@localhost:6432/postgres < schema.sql 
psql postgres://postgres:mypassword@localhost:6432/postgres < data.sql 

```

If you do not have `psql` available, you can copy the `schema.sql` and `data.sql` file to the postgres container and execute the `psql` command via inside it:


*Note*:  You can find `<postgres-container-ID>` with `docker ps`

```
docker cp schema.sql <postgres-container-ID>:/
docker cp data.sql <postgres-container-ID>:/
docker exec -ti <postgres-container-ID> /bin/bash
psql -U postgres < schema.sql
psql -U postgres < data.sql
```

## Track tables and foreign-key relations

![Track tables in console](images/Hasura_setup_track_tables.png)

Return to the Hasura GraphQL Engine console and select the Data tab. In the central view, there should be a section "Untracked tables or views" with several tables listed and a "Track All" option available. Select "Track All", and then "Track All" again for untracked foreign-key relations.

Now you're all set! You should see your tables listed in the left-hand panel.

Go to the Graphiql tab and start trying out queries, mutations, and subscriptions.


## Dataset

- Users: Users who are browsing and purchasing items
- Products: Inventory of products on sale
- Orders: Order information

## Exploring the GraphQL API

- Existing database
- CRUD
- Subscriptions

## Authn and Authz

- `x-hasura-admin-secret`
- Hasura Authz

## Model reads

- Define roles on models
- `x-hasura-role` and `x-hasura-user-id`
- Authorized models/views/functions

## Model writes (Actions)

- Place an order
- Create shipment (SaaS API)
- Create action relationship (remote join)

## Remote joins

- Add Remote Schema
- Create remote relationship

## Model events

- Sync with analytics db (data event)
- EOD reports (time event)
- Mark delivery complete (time event)

## CQRS and 3factor app
