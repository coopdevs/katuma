# katuma [![Build Status](https://travis-ci.org/coopdevs/katuma.png?branch=develop)](https://travis-ci.org/coopdevs/katuma)

Ruby on Rails app to foster collaborative consumption

## Available API endpoints

### Session
#### Log in
```
POST api/v1/sessions

{
  'email': 'user@email.com',
  'password': 'sosecret'
}
```
#### Log out
```
DELETE api/v1/sessions

{}
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
  'id': 1,
  'name': 'User name',
  'email': 'user@email.com',
  'created_at': '2014-09-06T11:48:39.072Z',
  'updated_at': '2014-09-06T11:48:39.072Z'
}
```
#### Create
```
POST api/v1/users

{
  'name': 'User name',
  'email': 'user@email.com',
  'password': 'sosecret',
  'password_confirmation': 'sosecret'
}
```

### Groups
#### Create
```
POST api/v1/groups

{
  'name': 'My group'
}
```

### Memberships
#### Create
```
POST api/v1/memberships

{
  'group_id': 1,
  'user_id': 1,
  'role': 1
}
```
A list of all the possible Group roles can be found in [app/models/membership.rb](app/models/membership.rb).

### Postman collection
[Postman](http://www.getpostman.com) users can download our [Postman collection](postman_collection.json).
