# linkrr app

## What is it?

Submit and share links...

## Where is it

deployment at "http://yourapphere.heroku.com"

## Components

Generic status codes to send

401 - user not authenticated
200 - sucesss
404 - no user found

## Params

Frontend : Sent in JSON encoded request body
Backend : Look in json

## Authorization Header

{ "Authorization": "username" }

## JSONs

Structure all JSON responses inside an array []

user
    {
    "avatar": "value",
    "first_name": "value",
    "last_name": "value",
    "username": "value",
    "location": "value",
    "joined_date": "YYYY-MM-DD",
    "saved_links": "a number",
    }
links
    {
    "title": "value",
    "url": "value",
    "description": "value",
    "timestamp": "YYYY-MM-DD HH:MM:SS"
    }

1. SUBMIT NEW LINK

    path - "/:user/newlinks"

    POST request
    - header "Authorization": "user"

    - params "title=" "url=" "description="

    do some back end stuff
    - check user
    - timestamp

    RESPONSE:

    send back status code

2. VIEW LINKS FOR A USER

   path - "/:user/links"

    json body of all links of user

2A user endoint - send back user profile

    path "/:user"

    json body of full user object

3. DELETE LINKS

   DELETE request

   path - "/:user/links/:link_id"

   - authorization header

    back end stuff

4. RECOMMEND LINKS TO ANOTHER USER

   use submit new link method backend will route?
