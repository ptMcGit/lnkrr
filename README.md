# linkrr app

## What is it?

Submit and share links...

## Where is it

deployment at "https://lnkrr.herokuapp.com"

## Components

### Status Codes

Generic status codes to send

    401 - user not authenticated
    200 - sucesss
    404 - no user found

### Params

- Frontend: Sent in JSON encoded request body
- Backend: Look in json

x = request.body.read #get the body
h = JSON.parse x #turn into a hash
rack testing
post /:user/newlinks {hash}.to_json

### Authorization Header

    { "Authorization": "username" }

### JSONs

Structure all JSON responses inside an array `[]`

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

### Endpoints

#### 1. SUBMIT NEW LINK

PATH - `/:user/links`

POST request

- header "Authorization": "user"
- params "title=" "url=" "description="

*do some back end stuff*

- check user
- timestamp

RESPONSE: status code

#### 2. VIEW LINKS FOR A USER

PATH - `/:user/links`

*do some back end stuff*

RESPONSE:

json body of all links of user

#### 2A user endoint - send back user profile

PATH "/:user"

*do some back end stuff*

RESPONSE:

json body of full user object

#### 3. DELETE LINKS

DELETE request

PATH - "/:user/links/:link_id"
    - authorization header

*do back end stuff*

RESPONSE: status code

#### 4. RECOMMEND LINKS TO ANOTHER USER

PATH - `/:user/recommended`

POST request

- header "Authorization": "user"
- params "title=" "url=" "description="

#### 5.  GET RECOMMENDED LINKS

GET REQUEST

PATH "/:user/recommended"

## Back End

### Data Models

### User Table

### Link Table

### Recommended Links Table ?
|User1 | Link_ID | User2|
Owner  |  Link URL | User recommended |
