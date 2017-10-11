# MASA YELP

- A Yelp API server powered by [Yelp Business APIs (v3)](https://www.yelp.com/developers/documentation/v3).
- Authenticated users can save businesses they like.

## Clone this project (optional)

```
git clone git@github.com:mnishiguchi/masa_yelp.git
cd masa_yelp
bundle install
touch .env
```

#### Get Yelp API key
- https://www.yelp.com/developers/documentation/v3
- Get your Client ID and Client Secret on Yelp Fusion dashboard

#### Set Yelp API key to ENV
- development: Add your Client ID and Client Secret to `.env` file.
- production: Set your Client ID and Client Secret to `YELP_API_KEY` and `YELP_API_SECRET` environment variables respectively.

## Usage

#### [Search API](https://www.yelp.com/developers/documentation/v3/business_search)
- `/businesses`
- required params: location or a set of latitude and longitude
- optional params: see [docs](https://www.yelp.com/developers/documentation/v3/business_search)

```
https://masa-yelp.herokuapp.com/businesses?location=washingtondc
https://masa-yelp.herokuapp.com/businesses?latitude=38.8977&longitude=-77.0365
https://masa-yelp.herokuapp.com/businesses?location=washingtondc&term=sushi
```

#### [Business API](https://www.yelp.com/developers/documentation/v3/business)
- `/businesses/:id`
- required params: id

```
https://masa-yelp.herokuapp.com/businesses/bul-washington
```

#### [Reviews API](https://www.yelp.com/developers/documentation/v3/business_reviews)
- `/businesses/:id/reviews`
- required params: id

```
https://masa-yelp.herokuapp.com/businesses/bul-washington/reviews
```

## Response JSON format
- The data content is the same as the fetched from Yelp API.
- Keys are camel-cased as opposed to the original being snake-cased.

#### Errors

```
Yelp API errors

{
  "error": {
    "code": "LOCATION_MISSING",
    "description": "You must specify either a location or a latitude and longitude to search."
  }
}

{
  "error: {
    "code": "NOT_FOUND",
    "description": "Resource could not be found."
  }
}

{
  "error: {
    "code": "VALIDATION_ERROR",
    "description": "Please specify a location or a latitude and longitude"
  }
}
```

```
masa-yelp errors

{
  "error": {
    "code": "MASA_YELP",
    "description": "Invalid params: must provide supported params"
  }
}
```

## Authentication
- See [devise_token_auth readme](https://github.com/lynndylanhurley/devise_token_auth#usage-tldr) for authentication routes.

#### Sign up
- Requires `email`, `password`, `password_confirmation`, and `confirm_success_url` params.
- A verification email will be sent to the email address provided.
- Upon clicking the link in the confirmation email, the API will redirect to the URL specified in `confirm_success_url`.

```bash
curl \
  -X POST \
  -d "email=user@example.com&password=password&password_confirmation=password&confirm_success_url=https://github.com/mnishiguchi/masa_yelp" \
  https://masa-yelp.herokuapp.com/auth
```

#### Sign in
- Requires `email` and `password` as params.
- This route will return a JSON representation of the User model on successful login along with the access-token and client in the header of the response.

```bash
curl \
  -v \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -X POST https://masa-yelp.herokuapp.com/auth/sign_in \
  -d '{"email":"user@example.com","password":"password"}'

  *   Trying 204.236.237.197...
  * Connected to masa-yelp.herokuapp.com (204.236.237.197) port 443 (#0)
  * TLS 1.2 connection using TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
  * Server certificate: *.herokuapp.com
  * Server certificate: DigiCert SHA2 High Assurance Server CA
  * Server certificate: DigiCert High Assurance EV Root CA
  > POST /auth/sign_in HTTP/1.1
  > Host: masa-yelp.herokuapp.com
  > User-Agent: curl/7.43.0
  > Content-Type: application/json
  > Accept: application/json
  > Content-Length: 50
  >
  * upload completely sent off: 50 out of 50 bytes
  < HTTP/1.1 200 OK
  < Server: Cowboy
  < Date: Wed, 11 Oct 2017 01:44:20 GMT
  < Connection: keep-alive
  < Content-Type: application/json; charset=utf-8
  < Access-Token: LMQ5VymKXkQpQ489wLeEcA
  < Token-Type: Bearer
  < Client: XLFT2klLQMGpYovhd0H4HA
  < Expiry: 1508895861
  < Uid: user@example.com
  < Vary: Origin
  < Etag: W/"a3a24e714b150d3103e33936723e52ba"
  < Cache-Control: max-age=0, private, must-revalidate
  < X-Request-Id: a048ea97-58e8-4fb2-8c2a-f089d65656e0
  < X-Runtime: 0.311657
  < Transfer-Encoding: chunked
  < Via: 1.1 vegur
  <
  * Connection #0 to host masa-yelp.herokuapp.com left intact
  {"data":{"id":1,"email":"user@example.com","provider":"email","uid":"user@example.com","name":"Example User","nickname":null,"image":null}}
```

#### Sign out

```bash
curl \
  -i \
  -X DELETE \
  https://masa-yelp.herokuapp.com/auth/sign_out \
  -F access-token="LMQ5VymKXkQpQ489wLeEcA" \
  -F client="XLFT2klLQMGpYovhd0H4HA" \
  -F uid="user@example.com"

HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Vary: Origin
ETag: W/"c955e57777ec0d73639dca6748560d00"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: 57e2e3d3-73fa-4000-80fe-ed8afeb71ea2
X-Runtime: 0.110075
Transfer-Encoding: chunked

{"success":true}
```

#### Like a business

```bash
curl \
  -i \
  -X POST \
  https://masa-yelp.herokuapp.com/businesses/bul-washington/like \
  -F access-token="LMQ5VymKXkQpQ489wLeEcA" \
  -F client="XLFT2klLQMGpYovhd0H4HA" \
  -F uid="user@example.com"

HTTP/1.1 201 Created
```

#### Undo liking of a business

```bash
curl \
  -i \
  -X DELETE \
  https://masa-yelp.herokuapp.com/businesses/bul-washington/like \
  -F access-token="LMQ5VymKXkQpQ489wLeEcA" \
  -F client="XLFT2klLQMGpYovhd0H4HA" \
  -F uid="user@example.com"

HTTP/1.1 204 No Content
```

![](erd.jpg)
