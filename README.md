# MASA_YELP

- A Yelp API server powered by [Yelp Business APIs (v3)](https://www.yelp.com/developers/documentation/v3).

## Set up

#### Clone this project

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

## Supported Yelp APIs

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
