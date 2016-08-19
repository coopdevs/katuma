# katuma [![Build Status](https://travis-ci.org/coopdevs/katuma.svg?branch=develop)](https://travis-ci.org/coopdevs/katuma) [![Code Climate](https://codeclimate.com/github/coopdevs/katuma/badges/gpa.svg)](https://codeclimate.com/github/coopdevs/katuma) [![Test Coverage](https://codeclimate.com/github/coopdevs/katuma/badges/coverage.svg)](https://codeclimate.com/github/coopdevs/katuma/coverage)

Ruby on Rails app to foster collaborative consumption

## Available API endpoints

### Sign up
#### Create
Request:
```
POST api/v1/signups

{
  "email": "user@email.com"
}
```
Response:
```
201 CREATED

{}
```
#### Show
Request:
```
GET api/v1/signups/:token
```
Response:
```
200 OK

{
  "email": "user@email.com"
}
```
#### Complete
Request:
```
POST api/v1/signups/complete/:token

{
  "username": "username",
  "password": "sosecret",
  "password_confirmation": "sosecret",
  "first_name": "User",
  "last_name": "Name"
}
```
Response:
```
200 OK

{
  "id": 1,
  "email": "user@email.com",
  "username": "username",
  "first_name": "User",
  "last_name": "Name"
  "created_at": "2014-09-06T11:48:39.072Z",
  "updated_at": "2014-09-06T11:48:39.072Z"
}
```

### Users
#### Get current user (account)
```
GET api/v1/account

{}
```
Response:
```
{
  "id": 1,
  "name": "User name",
  "email": "user@email.com",
  "created_at": "2014-09-06T11:48:39.072Z",
  "updated_at": "2014-09-06T11:48:39.072Z"
}
```
#### Get users in user network
*All the users that have a Membership with any of the user's groups*
```
GET api/v1/users

{}
```
Response:
```
[
  {
    "id": 1,
    "name": "User name",
    "email": "user@email.com",
    "created_at": "2014-09-06T11:48:39.072Z",
    "updated_at": "2014-09-06T11:48:39.072Z"
  },
  {
    "id":2,
    "name":"Other user",
    "email":"other@hola.com",
    "created_at":"2014-08-31T18:40:40.255Z",
    "updated_at":"2014-08-31T18:40:40.255Z"
  }
]
```

### Groups
#### Create
```
POST api/v1/groups

{
  "name": "My group"
}
```

### Memberships
#### Create
```
POST api/v1/memberships

{
  "group_id": 1,
  "user_id": 1,
  "role": 1
}
```
A list of all the possible Group roles can be found in [app/models/membership.rb](app/models/membership.rb).

### Postman collection
[Postman](http://www.getpostman.com) users can download our [Postman collection](postman_collection.json).

## Postgrest start
`pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`
