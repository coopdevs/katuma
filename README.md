# katuma [![Build Status](https://travis-ci.org/coopdevs/katuma.png?branch=develop)](https://travis-ci.org/coopdevs/katuma)

Ruby on Rails app to foster collaborative consumption

## Available API endpoints

### Users
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

### Sessions
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
