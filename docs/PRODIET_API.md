# Traveler Platform API - Full API Documentation

**Version:** 1.0.0  
**OpenAPI:** 3.0.0  
**Source:** https://test.prodiet.cloud/api/documentation  
**Base URL (relative):** `/api/v1` - Production — API v1 base path  
**Production base:** `https://test.prodiet.cloud/api/v1`

## Description

## Traveler Platform REST API — Version 1.0

A complete travel booking platform API supporting Tours, Hotels, Activities,
Transports, Visas, Blogs, Destinations, Bookings, Payments, and Wallet.

### Authentication
Most write operations and personal data endpoints require a **Bearer Token**
obtained from `POST /api/v1/auth/login`.
Pass it in every protected request as:
```
Authorization: Bearer <token>
```

### Standard Response Envelope
All endpoints (except `/auth/login` and `/home`) wrap their data in:
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Human-readable error",
  "error_code": "MACHINE_CODE"
}
```

### Common Error Codes
| Code | Meaning |
|------|---------|
| `VALIDATION_ERROR` | Request body/params failed validation |
| `AUTH_001` | Invalid credentials |
| `NOT_FOUND` | Resource not found |
| `REVIEW_EXISTS` | User already reviewed this item |
| `ALREADY_PAID` | Order already paid |
| `METHOD_UNAVAILABLE` | Payment method not active |
| `PAYMENT_FAILED` | Gateway error |

## Security Schemes

- **bearerAuth** - type: `http`, scheme: `bearer`, bearerFormat: `JWT`

## Table of Contents

- [Authentication](#authentication) - 7 endpoints
- [Home](#home) - 1 endpoints
- [Explore](#explore) - 1 endpoints
- [Categories](#categories) - 1 endpoints
- [Tours](#tours) - 2 endpoints
- [Hotels](#hotels) - 2 endpoints
- [Activities](#activities) - 2 endpoints
- [Packages](#packages) - 2 endpoints
- [Destinations](#destinations) - 2 endpoints
- [Blogs](#blogs) - 4 endpoints
- [Visas](#visas) - 2 endpoints
- [Transports](#transports) - 2 endpoints
- [Wishlist](#wishlist) - 3 endpoints
- [Bookings](#bookings) - 5 endpoints
- [Payments](#payments) - 2 endpoints
- [Reviews](#reviews) - 1 endpoints
- [Profile](#profile) - 3 endpoints
- [Wallet](#wallet) - 4 endpoints
- [Account / Devices](#account-devices) - 3 endpoints
- [eSIM (Authenticated)](#esim-authenticated) - 6 endpoints
- [eSIM (Browse)](#esim-browse) - 4 endpoints

---

## Authentication

_Register, login, OTP verification, password reset, logout_

### `POST /api/v1/auth/login` - Login

Authenticate with email + password.

**Note:** The login response is a *flat* object (no `success/data` wrapper).

On success returns a Sanctum token and basic user info.
On failure returns `401` with `error_code: AUTH_001`.

**operationId:** `authLogin`  

**Request Body:**

- Content-Type: `application/json`
- `email` **required**: `string(email)` - Registered email address | example: `ahmed@example.com`
- `password` **required**: `string(password)` - Account password (min 6 characters) | example: `secret123`

**Responses:**

- **200** - Authenticated successfully
  - schema (`application/json`):
    - `token`: `string` - Bearer token to use in Authorization header | example: `3|Abc123XyzToken...`
    - `user`: `object`
      - `id`: `string` - example: `42`
      - `name`: `string` - example: `Ahmed Ali`
      - `email`: `string(email)` - example: `ahmed@example.com`
      - `phone`: `string` - example: `+966501234567`
      - `avatar_url`: `string` - example: `/uploads/users/avatar.jpg`
- **400** - Validation error — missing or invalid fields
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `The email field is required.`
    - `error_code`: `string` - example: `VALIDATION_ERROR`
- **401** - Wrong email or password
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Invalid credentials`
    - `error_code`: `string` - example: `AUTH_001`

---

### `POST /api/v1/auth/register` - Register

Create a new user account.

- `name` is split into `fname` / `lname` internally.
- A unique `username` is auto-generated from the email prefix.
- Account is active immediately (no email verification gate).

**operationId:** `authRegister`  

**Request Body:**

- Content-Type: `application/json`
- `name` **required**: `string` - Full name (first + last) | example: `Sara Hassan`
- `email` **required**: `string(email)` - Must be unique | example: `sara@example.com`
- `password` **required**: `string(password)` - Minimum 6 characters | example: `myPass99`

**Responses:**

- **200** - Account created
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `User registered successfully.`
    - `data`: `object`
      - `id`: `string` - example: `15`
      - `name`: `string` - example: `Sara Hassan`
      - `email`: `string` - example: `sara@example.com`
- **400** - Validation error — e.g. email already taken
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `The email has already been taken.`
    - `error_code`: `string` - example: `VALIDATION_ERROR`

---

### `POST /api/v1/auth/verify-otp` - Verify OTP

Verify the OTP code sent to the user's email after registration.

**operationId:** `authVerifyOtp`  

**Request Body:**

- Content-Type: `application/json`
- `email` **required**: `string(email)` - example: `sara@example.com`
- `otp` **required**: `string` - 6-digit OTP received by email | example: `482910`

**Responses:**

- **200** - OTP accepted
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `OTP verified successfully.`
    - `data`: `string`
- **400** - Missing or invalid OTP / email
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `The otp field is required.`
    - `error_code`: `string` - example: `VALIDATION_ERROR`

---

### `POST /api/v1/auth/forgot-password` - Forgot Password

Request a password-reset OTP. The email must belong to an existing account.

**operationId:** `authForgotPassword`  

**Request Body:**

- Content-Type: `application/json`
- `email` **required**: `string(email)` - example: `ahmed@example.com`

**Responses:**

- **200** - OTP dispatched
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Password reset OTP sent to your email.`
    - `data`: `string`
- **400** - Email not found in system
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `The selected email is invalid.`
    - `error_code`: `string` - example: `VALIDATION_ERROR`

---

### `POST /api/v1/auth/reset-password` - Reset Password

Set a new password using the OTP received by email. The OTP is validated server-side.

**operationId:** `authResetPassword`  

**Request Body:**

- Content-Type: `application/json`
- `email` **required**: `string(email)` - example: `ahmed@example.com`
- `otp` **required**: `string` - example: `482910`
- `new_password` **required**: `string(password)` - Minimum 6 characters | example: `newSecure99`

**Responses:**

- **200** - Password changed
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Password has been reset successfully.`
    - `data`: `string`
- **400** - Validation error
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `The new password field is required.`
    - `error_code`: `string` - example: `VALIDATION_ERROR`

---

### `POST /api/v1/auth/logout` - Logout

Revoke the current Sanctum token. The token is unusable after this call.

**operationId:** `authLogout`  
**Auth:** `bearerAuth` (Bearer token required)  

**Responses:**

- **200** - Token revoked
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Logged out successfully.`
    - `data`: `string`
- **401** - Token missing or already expired
  - schema (`application/json`):
    - `message`: `string` - example: `Unauthenticated.`

---

### `DELETE /api/v1/auth/account` - Delete Account

Permanently delete the authenticated user's account and revoke all tokens. **Irreversible.**

**operationId:** `authDeleteAccount`  
**Auth:** `bearerAuth` (Bearer token required)  

**Responses:**

- **200** - Account deleted
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Account deleted successfully.`
    - `data`: `string`
- **401** - Unauthenticated

---

## Home

_Aggregated home-screen data: banners, destinations, tours, hotels_

### `GET /api/v1/home` - Get Home Data

Returns aggregated data for the app's home/dashboard screen.

**Response structure** (flat — no `success/data` wrapper):
- `banners` — up to 5 promotional banners
- `destinations` — up to 10 destinations
- `tours` — up to 10 active tours with average rating
- `hotels` — up to 10 active hotels with rating and price per night

**operationId:** `homeIndex`  

**Responses:**

- **200** - Home data
  - schema (`application/json`):
    - `banners`: `array<object>`
      - `id`: `string` - example: `1`
      - `image_url`: `string` - example: `/uploads/advertisement/banner1.jpg`
      - `title`: `string` - example: `Summer Deals 2025`
      - `link`: `string` - example: ``
    - `destinations`: `array<object>`
      - `id`: `string` - example: `5`
      - `name`: `string` - example: `Dubai`
      - `image_url`: `string` - example: `/uploads/destination/features/dubai.jpg`
    - `tours`: `array<object>`
      - `id`: `string` - example: `12`
      - `title`: `string` - example: `Desert Safari Experience`
      - `image_url`: `string` - example: `/uploads/tour/features/safari.jpg`
      - `price`: `number(double)` - example: `350`
      - `rating`: `number(double)` - example: `4.7`
    - `hotels`: `array<object>`
      - `id`: `string` - example: `8`
      - `name`: `string` - example: `Grand Hyatt Riyadh`
      - `image_url`: `string` - example: `/uploads/hotel/features/hyatt.jpg`
      - `rating`: `number(double)` - example: `4.9`
      - `price_per_night`: `number(double)` - example: `850`
      - `location`: `string` - example: `Riyadh`

---

## Explore

_Full-text search and filter across Tours, Hotels, Activities and Transports with pagination_

### `GET /api/v1/explore` - Search & Filter

Full-text search and filter across Tours and Hotels in a single merged list.

- Omit `category` to search both Tours and Hotels simultaneously.
- `min_rating` is applied only to Hotels (server-side filtering after query).
- Results are manually paginated from the merged collection.

**Response** is a *flat* object (no `success/data` wrapper).

**operationId:** `exploreIndex`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `q` | `string` |  | Search keyword (matches title) |
| query | `category` | `string enum=['Tours', 'Hotels']` |  | Limit results to one product type |
| query | `min_price` | `number(double)` |  | Minimum price (SAR/USD) |
| query | `max_price` | `number(double)` |  | Maximum price |
| query | `min_rating` | `number(double)` |  | Minimum average rating (Hotels only) |
| query | `page` | `integer` |  | Page number (default: 1) |
| query | `per_page` | `integer` |  | Items per page (default: 20) |

**Responses:**

- **200** - Search results
  - schema (`application/json`):
    - `items`: `array<object>`
      - `id`: `string` - example: `12`
      - `title`: `string` - example: `Desert Safari Experience`
      - `category`: `string enum=['Tours', 'Hotels']` - example: `Tours`
      - `price`: `number(double)` - example: `350`
      - `rating`: `number(double)` - example: `4.7`
      - `image_url`: `string` - example: `/uploads/tour/features/safari.jpg`
    - `meta`: `object`
      - `current_page`: `integer` - example: `1`
      - `has_more`: `boolean` - example: `True`

---

## Categories

_Browse product categories (tours, etc.)_

### `GET /api/v1/categories` - List Categories

Returns categories for the given product type. Currently supports `tour`.

**operationId:** `getCategories`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `type` | `string enum=['tour']` |  | Product type to fetch categories for |

**Responses:**

- **200** - Categories retrieved successfully
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Data retrieved successfully.`
    - `data`: `object`
      - `type`: `string` - example: `tour`
      - `categories`: `array<object>`
        - `id`: `string` - example: `1`
        - `name`: `string` - example: `Desert Tours`
        - `slug`: `string` - example: `desert-tours`
        - `icon`: `string` - example: `las la-sun`

---

## Tours

_Tour listing (with filters) and product detail_

### `GET /api/v1/tours/{slug}` - Get Tour Detail

Returns full detail for a single active tour identified by its URL slug.

- Increments the tour's view counter on each call.
- `highlights`, `includes`, `excludes`, `itinerary`, `faqs`, `person_types`,
  and `fixed_dates` are stored as JSON and decoded to arrays.
- Only approved reviews (`status=1`, no parent) are returned.

**operationId:** `tourShow`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `slug` | `string` | YES | URL slug of the tour |

**Responses:**

- **200** - Tour found
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `id`: `string` - example: `12`
      - `title`: `string` - example: `Desert Safari Experience`
      - `slug`: `string` - example: `desert-safari-dubai`
      - `description`: `string` - example: `A thrilling desert adventure...`
      - `image_url`: `string` - example: `/uploads/tour/features/safari.jpg`
      - `gallery`: `array<string>`
      - `price`: `number(double)` - example: `350`
      - `duration`: `string` - example: `6 Hours`
      - `category`: `string` - example: `Adventure`
      - `destination`: `string` - example: `Dubai`
      - `location`: `string` - example: `Dubai Desert Conservation Reserve`
      - `highlights`: `array<string>`
      - `includes`: `array<string>`
      - `excludes`: `array<string>`
      - `itinerary`: `array<object>`
        - `day`: `string` - example: `Day 1`
        - `title`: `string` - example: `Departure & Dune Drive`
        - `description`: `string` - example: `Pick-up at 3 PM, head to the desert...`
      - `faqs`: `array<object>`
        - `question`: `string` - example: `What should I wear?`
        - `answer`: `string` - example: `Comfortable loose clothing recommended.`
      - `person_types`: `array<object>`
        - `type`: `string` - example: `adult`
        - `price`: `number` - example: `350`
      - `fixed_dates`: `array<string(date)>`
      - `total_reviews`: `integer` - example: `24`
      - `average_rating`: `number(double)` - example: `4.6`
      - `reviews`: `array<object>`
        - `id`: `integer` - example: `7`
        - `rating`: `number(double)` - example: `5`
        - `comment`: `string` - example: `Absolutely amazing experience!`
        - `reviewer`: `string` - example: `Khalid Mohammed`
        - `avatar_url`: `string` - example: `/uploads/users/avatar.jpg`
        - `created_at`: `string(date)` - example: `2025-03-10`
- **404** - Tour not found or inactive
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Tour not found`
    - `error_code`: `string` - example: `TOUR_404`

---

### `GET /api/v1/tours` - List Tours

Paginated tour listing with optional filters and sorting.

**operationId:** `listTours`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `q` | `string` |  | Keyword search |
| query | `category_id` | `integer` |  | Filter by tour category ID |
| query | `destination_id` | `integer` |  | Filter by destination ID |
| query | `country_id` | `integer` |  | Filter by country ID |
| query | `price_min` | `number` |  | Minimum price filter |
| query | `price_max` | `number` |  | Maximum price filter |
| query | `duration` | `string` |  | Filter by duration label (e.g. '3 Days') |
| query | `sort` | `string enum=['latest', 'price_asc', 'price_desc', 'popular', 'top_rated']` |  | Sort order |
| query | `per_page` | `integer` |  | Items per page (default 12) |

**Responses:**

- **200** - Tours retrieved successfully
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Tours retrieved successfully.`
    - `data`: `object`
      - `items`: `array<object>`
        - `id`: `integer` - example: `1`
        - `title`: `string` - example: `Desert Safari`
        - `slug`: `string` - example: `desert-safari`
        - `price`: `number(double)` - example: `120`
        - `sale_price`: `number(double)` - example: `99`
        - `duration`: `string` - example: `3 Days`
        - `image_url`: `string` - example: `/uploads/tours/features/img.jpg`
        - `avg_rating`: `number(double)` - example: `4.5`
        - `review_count`: `integer` - example: `12`
      - `meta`: `object`
        - `total`: `integer` - example: `50`
        - `per_page`: `integer` - example: `12`
        - `current_page`: `integer` - example: `1`
        - `last_page`: `integer` - example: `5`

---

## Hotels

_Hotel listing (with filters) and product detail_

### `GET /api/v1/hotels/{slug}` - Get Hotel Detail

Returns full detail for a single active hotel. Increments view counter.

**operationId:** `hotelShow`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `slug` | `string` | YES | Hotel URL slug |

**Responses:**

- **200** - Hotel found
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `id`: `string` - example: `8`
      - `name`: `string` - example: `Grand Hyatt Riyadh`
      - `slug`: `string` - example: `grand-hyatt-riyadh`
      - `description`: `string` - example: `5-star luxury hotel...`
      - `image_url`: `string` - example: `/uploads/hotel/features/hyatt.jpg`
      - `gallery`: `array<string>`
      - `price_per_night`: `number(double)` - example: `850`
      - `location`: `string` - example: `Riyadh`
      - `country`: `string` - example: `Saudi Arabia`
      - `address`: `string` - example: `King Abdullah Road, Riyadh 12271`
      - `policies`: `array<object>`
        - `title`: `string` - example: `Check-in`
        - `description`: `string` - example: `From 3:00 PM`
      - `total_reviews`: `integer` - example: `18`
      - `average_rating`: `number(double)` - example: `4.9`
      - `reviews`: `array<object>`
        - `id`: `integer` - example: `3`
        - `rating`: `number(double)` - example: `5`
        - `comment`: `string` - example: `Exceptional service!`
        - `reviewer`: `string` - example: `Fatima Al-Rashid`
        - `avatar_url`: `string`
        - `created_at`: `string(date)` - example: `2025-02-14`
- **404** - Hotel not found
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Hotel not found`
    - `error_code`: `string` - example: `HOTEL_404`

---

### `GET /api/v1/hotels` - List Hotels

Paginated hotel listing with optional filters and sorting.

**operationId:** `listHotels`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `q` | `string` |  | Keyword search |
| query | `country_id` | `integer` |  | Filter by country ID |
| query | `city_id` | `integer` |  | Filter by city ID |
| query | `price_min` | `number` |  | Minimum price per night |
| query | `price_max` | `number` |  | Maximum price per night |
| query | `sort` | `string enum=['latest', 'price_asc', 'price_desc', 'popular', 'top_rated']` |  | Sort order |
| query | `per_page` | `integer` |  | Items per page (default 12) |

**Responses:**

- **200** - Hotels retrieved successfully
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Hotels retrieved successfully.`
    - `data`: `object`
      - `items`: `array<object>`
        - `id`: `integer` - example: `1`
        - `title`: `string` - example: `Grand Palace Hotel`
        - `slug`: `string` - example: `grand-palace-hotel`
        - `price_per_night`: `number(double)` - example: `200`
        - `sale_price`: `number(double)` - example: `180`
        - `location`: `string` - example: `Dubai Marina`
        - `country`: `string` - example: `UAE`
        - `image_url`: `string` - example: `/uploads/hotels/features/img.jpg`
        - `avg_rating`: `number(double)` - example: `4.7`
        - `review_count`: `integer` - example: `34`
      - `meta`: `object`
        - `total`: `integer` - example: `30`
        - `per_page`: `integer` - example: `12`
        - `current_page`: `integer` - example: `1`
        - `last_page`: `integer` - example: `3`

---

## Activities

_Activity listing (with filters) and product detail_

### `GET /api/v1/activities/{slug}` - Get Activity Detail

Returns full detail for a single active activity. Increments view counter.

**operationId:** `activityShow`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `slug` | `string` | YES | Activity URL slug |

**Responses:**

- **200** - Activity found
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `id`: `string` - example: `3`
      - `title`: `string` - example: `Scuba Diving at Red Sea`
      - `slug`: `string` - example: `scuba-diving-red-sea`
      - `description`: `string` - example: `Discover the magnificent coral reefs...`
      - `image_url`: `string` - example: `/uploads/activities/features/scuba.jpg`
      - `gallery`: `array<string>`
      - `price`: `number(double)` - example: `200`
      - `duration`: `string` - example: `3 Hours`
      - `location`: `string` - example: `Jeddah`
      - `country`: `string` - example: `Saudi Arabia`
      - `highlights`: `array<string>`
      - `includes`: `array<string>`
      - `excludes`: `array<string>`
      - `plan`: `array<object>`
      - `faqs`: `array<object>`
      - `total_reviews`: `integer` - example: `9`
      - `average_rating`: `number(double)` - example: `4.8`
      - `reviews`: `array<object>`
- **404** - Activity not found
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Activity not found`
    - `error_code`: `string` - example: `ACTIVITY_404`

---

### `GET /api/v1/activities` - List Activities

Paginated activity listing with optional filters and sorting.

**operationId:** `listActivities`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `q` | `string` |  | Keyword search |
| query | `country_id` | `integer` |  | Filter by country ID |
| query | `city_id` | `integer` |  | Filter by city ID |
| query | `price_min` | `number` |  | Minimum price |
| query | `price_max` | `number` |  | Maximum price |
| query | `sort` | `string enum=['latest', 'price_asc', 'price_desc', 'popular', 'top_rated']` |  | Sort order |
| query | `per_page` | `integer` |  | Items per page (default 12) |

**Responses:**

- **200** - Activities retrieved successfully
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Activities retrieved successfully.`
    - `data`: `object`
      - `items`: `array<object>`
        - `id`: `integer` - example: `1`
        - `title`: `string` - example: `Scuba Diving`
        - `slug`: `string` - example: `scuba-diving`
        - `price`: `number(double)` - example: `75`
        - `sale_price`: `number(double)` - example: `60`
        - `days`: `integer` - example: `1`
        - `nights`: `integer` - example: `0`
        - `image_url`: `string` - example: `/uploads/activities/features/img.jpg`
        - `avg_rating`: `number(double)` - example: `4.3`
        - `review_count`: `integer` - example: `8`
      - `meta`: `object`
        - `total`: `integer` - example: `25`
        - `per_page`: `integer` - example: `12`
        - `current_page`: `integer` - example: `1`
        - `last_page`: `integer` - example: `3`

---

## Packages

_Travel package listing and detail_

### `GET /api/v1/packages` - List Packages

Paginated travel package listing with optional filters and sorting.

**operationId:** `listPackages`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `q` | `string` |  | Keyword search |
| query | `country_id` | `integer` |  | Filter by country ID |
| query | `price_min` | `number` |  | Minimum price |
| query | `price_max` | `number` |  | Maximum price |
| query | `days` | `integer` |  | Filter by number of days |
| query | `featured` | `integer enum=[0, 1]` |  | Return only featured packages (1=yes) |
| query | `sort` | `string enum=['latest', 'price_asc', 'price_desc', 'popular', 'top_rated']` |  | Sort order |
| query | `per_page` | `integer` |  | Items per page (default 12) |

**Responses:**

- **200** - Packages retrieved successfully
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Packages retrieved successfully.`
    - `data`: `object`
      - `items`: `array<object>`
        - `id`: `integer` - example: `1`
        - `title`: `string` - example: `Egypt Classic 7 Days`
        - `slug`: `string` - example: `egypt-classic-7-days`
        - `short_desc`: `string` - example: `Explore Cairo, Luxor and Aswan`
        - `price`: `number(double)` - example: `899`
        - `sale_price`: `number(double)` - example: `799`
        - `duration`: `string` - example: `7 Days / 6 Nights`
        - `days`: `integer` - example: `7`
        - `nights`: `integer` - example: `6`
        - `is_featured`: `boolean` - example: `True`
        - `image_url`: `string` - example: `/uploads/packages/features/img.jpg`
        - `avg_rating`: `number(double)` - example: `4.6`
        - `review_count`: `integer` - example: `20`
      - `meta`: `object`
        - `total`: `integer` - example: `18`
        - `per_page`: `integer` - example: `12`
        - `current_page`: `integer` - example: `1`
        - `last_page`: `integer` - example: `2`

---

### `GET /api/v1/packages/{slug}` - Package Detail

Full details for a single travel package including itinerary, includes/excludes, gallery and reviews.

**operationId:** `showPackage`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `slug` | `string` | YES | Package slug |

**Responses:**

- **200** - Package details retrieved successfully
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Package details retrieved successfully.`
    - `data`: `object`
      - `id`: `integer` - example: `1`
      - `title`: `string` - example: `Egypt Classic 7 Days`
      - `slug`: `string` - example: `egypt-classic-7-days`
      - `short_desc`: `string`
      - `content`: `string`
      - `price`: `number(double)` - example: `899`
      - `sale_price`: `number(double)`
      - `duration`: `string` - example: `7 Days / 6 Nights`
      - `days`: `integer` - example: `7`
      - `nights`: `integer` - example: `6`
      - `is_featured`: `boolean` - example: `True`
      - `image_url`: `string`
      - `gallery`: `array<string>`
      - `includes`: `array<string>`
      - `excludes`: `array<string>`
      - `highlights`: `array<string>`
      - `destinations`: `array<string>`
      - `itinerary`: `array<object>`
      - `faqs`: `array<object>`
      - `avg_rating`: `number(double)` - example: `4.6`
      - `review_count`: `integer` - example: `20`
      - `reviews`: `array<object>`
- **404** - Package not found

---

## Destinations

_Browse and view travel destinations_

### `GET /api/v1/destinations` - List Destinations

Paginated list of all travel destinations, newest first.

**operationId:** `destinationIndex`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `page` | `integer` |  | Page number (default: 1) |
| query | `per_page` | `integer` |  | Items per page (default: 20) |

**Responses:**

- **200** - Destination list
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `items`: `array<object>`
        - `id`: `string` - example: `5`
        - `name`: `string` - example: `Dubai`
        - `slug`: `string` - example: `dubai`
        - `image_url`: `string` - example: `/uploads/destination/features/dubai.jpg`
      - `meta`: `object`
        - `current_page`: `integer` - example: `1`
        - `per_page`: `integer` - example: `20`
        - `total`: `integer` - example: `35`
        - `has_more`: `boolean` - example: `True`

---

### `GET /api/v1/destinations/{slug}` - Get Destination Detail

Returns destination details including up to 10 active linked tours.

**operationId:** `destinationShow`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `slug` | `string` | YES | Destination slug |

**Responses:**

- **200** - Destination found
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `id`: `string` - example: `5`
      - `name`: `string` - example: `Dubai`
      - `slug`: `string` - example: `dubai`
      - `description`: `string` - example: `City of gold and innovation...`
      - `image_url`: `string` - example: `/uploads/destination/features/dubai.jpg`
      - `tours`: `array<object>`
        - `id`: `string` - example: `12`
        - `title`: `string` - example: `Desert Safari Experience`
        - `slug`: `string` - example: `desert-safari-dubai`
        - `image_url`: `string` - example: `/uploads/tour/features/safari.jpg`
        - `price`: `number(double)` - example: `350`
        - `rating`: `number(double)` - example: `4.7`
- **404** - Destination not found
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Destination not found`
    - `error_code`: `string` - example: `DESTINATION_404`

---

## Blogs

_Blog listing, article detail and comments_

### `GET /api/v1/blogs` - List Blog Posts

Paginated list of published blog posts. Optionally filter by category slug.

**operationId:** `blogIndex`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `category` | `string` |  | Filter by blog category slug |
| query | `page` | `integer` |  | Page number (default: 1) |
| query | `per_page` | `integer` |  | Items per page (default: 15) |

**Responses:**

- **200** - Blog list
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `items`: `array<object>`
        - `id`: `string` - example: `9`
        - `title`: `string` - example: `Top 10 Things to Do in Dubai`
        - `slug`: `string` - example: `top-10-things-dubai`
        - `excerpt`: `string` - example: `Dubai never stops surprising travellers...`
        - `image_url`: `string` - example: `/uploads/blog/feature/dubai-guide.jpg`
        - `category`: `string` - example: `Travel Tips`
        - `author`: `string` - example: `Mohammed Al-Zahrani`
        - `published_at`: `string(date)` - example: `2025-01-20`
      - `meta`: `object`
        - `current_page`: `integer` - example: `1`
        - `per_page`: `integer` - example: `15`
        - `total`: `integer` - example: `42`
        - `has_more`: `boolean` - example: `True`

---

### `GET /api/v1/blogs/{slug}` - Get Blog Post Detail

Returns the full content of a single published blog post.

**operationId:** `blogShow`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `slug` | `string` | YES | Blog post slug |

**Responses:**

- **200** - Blog post found
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `id`: `string` - example: `9`
      - `title`: `string` - example: `Top 10 Things to Do in Dubai`
      - `slug`: `string` - example: `top-10-things-dubai`
      - `content`: `string` - example: `<p>Dubai is a city that...</p>`
      - `excerpt`: `string` - example: `Dubai never stops surprising travellers...`
      - `image_url`: `string` - example: `/uploads/blog/feature/dubai-guide.jpg`
      - `category`: `string` - example: `Travel Tips`
      - `author`: `string` - example: `Mohammed Al-Zahrani`
      - `tags`: `array<string>`
      - `published_at`: `string(date)` - example: `2025-01-20`
- **404** - Blog post not found
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Blog post not found`
    - `error_code`: `string` - example: `BLOG_404`

---

### `GET /api/v1/blogs/{slug}/comments` - List Blog Comments

Returns approved top-level comments with nested replies for a blog post.

**operationId:** `getBlogComments`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `slug` | `string` | YES | Blog post slug |

**Responses:**

- **200** - Comments retrieved successfully
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Comments retrieved successfully.`
    - `data`: `array<object>`
      - `id`: `integer` - example: `1`
      - `name`: `string` - example: `Ahmed Ali`
      - `comment`: `string` - example: `Great article!`
      - `created_at`: `string(date)` - example: `2026-04-15`
      - `replies`: `array<object>`
        - `id`: `integer` - example: `5`
        - `name`: `string` - example: `Admin`
        - `comment`: `string` - example: `Thank you!`
        - `created_at`: `string(date)` - example: `2026-04-16`
        - `replies`: `array<object>`
- **404** - Blog post not found

---

### `POST /api/v1/blogs/{slug}/comments` - Post a Comment

Submit a comment on a blog post. Authentication is optional — if unauthenticated, `name` and `email` are required.

**operationId:** `storeBlogComment`  
**Auth:** `bearerAuth` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `slug` | `string` | YES | Blog post slug |

**Request Body:**

- Content-Type: `application/json`
- `comment` **required**: `string` - Comment text | example: `Really enjoyed this post!`
- `name`: `string` - Required when unauthenticated | example: `John Doe`
- `email`: `string(email)` - Required when unauthenticated | example: `john@example.com`
- `parent_id`: `integer` - Parent comment ID for replies

**Responses:**

- **201** - Comment submitted successfully
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Comment submitted successfully.`
    - `data`: `object`
      - `id`: `integer` - example: `10`
      - `name`: `string` - example: `John Doe`
      - `comment`: `string` - example: `Really enjoyed this post!`
      - `created_at`: `string(date)` - example: `2026-05-01`
      - `replies`: `array<object>`
- **404** - Blog post not found
- **422** - Validation error

---

## Visas

_Visa listing and detail_

### `GET /api/v1/visas` - List Visas

Paginated list of active visas. Optionally filter by `country_id`.

**operationId:** `visaIndex`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `country_id` | `integer` |  | Filter by destination country ID |
| query | `page` | `integer` |  | Page number (default: 1) |
| query | `per_page` | `integer` |  | Items per page (default: 20) |

**Responses:**

- **200** - Visa list
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `items`: `array<object>`
        - `id`: `string` - example: `2`
        - `title`: `string` - example: `UAE Tourist Visa`
        - `slug`: `string` - example: `uae-tourist-visa`
        - `image_url`: `string` - example: `/uploads/visa/features/uae.jpg`
        - `cost`: `number(double)` - example: `380`
        - `country`: `string` - example: `United Arab Emirates`
        - `category`: `string` - example: `Tourist`
        - `validity`: `string` - example: `30 Days`
        - `processing`: `string` - example: `3-5 Business Days`
      - `meta`: `object`
        - `current_page`: `integer` - example: `1`
        - `per_page`: `integer` - example: `20`
        - `total`: `integer` - example: `12`
        - `has_more`: `boolean` - example: `False`

---

### `GET /api/v1/visas/{slug}` - Get Visa Detail

Returns full details for a single active visa including includes list and FAQs.

**operationId:** `visaShow`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `slug` | `string` | YES | Visa slug |

**Responses:**

- **200** - Visa found
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `id`: `string` - example: `2`
      - `title`: `string` - example: `UAE Tourist Visa`
      - `slug`: `string` - example: `uae-tourist-visa`
      - `image_url`: `string` - example: `/uploads/visa/features/uae.jpg`
      - `banner_url`: `string` - example: `/uploads/visa/banner/uae-banner.jpg`
      - `cost`: `number(double)` - example: `380`
      - `country`: `string` - example: `United Arab Emirates`
      - `country_id`: `integer` - example: `3`
      - `category`: `string` - example: `Tourist`
      - `validity`: `string` - example: `30 Days`
      - `processing`: `string` - example: `3-5 Business Days`
      - `maximum_stay`: `string` - example: `30 Days`
      - `visa_mode`: `string` - example: `E-Visa`
      - `includes`: `array<string>`
      - `faqs`: `array<object>`
- **404** - Visa not found
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Visa not found.`
    - `error_code`: `string` - example: `VISA_404`

---

## Transports

_Transport listing and detail with multi-modal pricing_

### `GET /api/v1/transports` - List Transports

Paginated list of active transport options with car price and rating.

**operationId:** `transportIndex`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `page` | `integer` |  | Page number (default: 1) |
| query | `per_page` | `integer` |  | Items per page (default: 20) |

**Responses:**

- **200** - Transport list
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `items`: `array<object>`
        - `id`: `string` - example: `4`
        - `title`: `string` - example: `Dubai Airport Transfer`
        - `slug`: `string` - example: `dubai-airport-transfer`
        - `image_url`: `string` - example: `/uploads/transport/features/transfer.jpg`
        - `car_price`: `number(double)` - example: `120`
        - `location`: `string` - example: `Dubai`
        - `rating`: `number(double)` - example: `4.5`
      - `meta`: `object`
        - `current_page`: `integer` - example: `1`
        - `per_page`: `integer` - example: `20`
        - `total`: `integer` - example: `8`
        - `has_more`: `boolean` - example: `False`

---

### `GET /api/v1/transports/{slug}` - Get Transport Detail

Returns full transport detail including multi-modal pricing.

**Pricing object** contains prices per transport mode:
- `car` — car price + sale price
- `train` — adult + child price
- `bus` — adult + child price
- `boat` — price + sale price

Use the `transport_type` field when creating a booking.

**operationId:** `transportShow`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `slug` | `string` | YES | Transport slug |

**Responses:**

- **200** - Transport found
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `id`: `string` - example: `4`
      - `title`: `string` - example: `Dubai Airport Transfer`
      - `slug`: `string` - example: `dubai-airport-transfer`
      - `description`: `string` - example: `Comfortable and reliable airport transfers...`
      - `image_url`: `string` - example: `/uploads/transport/features/transfer.jpg`
      - `gallery`: `array<string>`
      - `location`: `string` - example: `Dubai`
      - `country`: `string` - example: `United Arab Emirates`
      - `address`: `string` - example: `Dubai International Airport`
      - `car_type`: `string` - example: `Sedan`
      - `distance_km`: `string` - example: `45 km`
      - `min_stay`: `string` - example: `1 Day`
      - `pricing`: `object`
        - `car`: `object`
          - `price`: `number` - example: `120`
          - `sale_price`: `number` - example: `100`
        - `train`: `object`
          - `price`: `number` - example: `50`
          - `child_price`: `number` - example: `25`
        - `bus`: `object`
          - `price`: `number` - example: `20`
          - `child_price`: `number` - example: `10`
        - `boat`: `object`
          - `price`: `number` - example: `200`
          - `sale_price`: `number` - example: `180`
      - `faqs`: `array<object>`
      - `total_reviews`: `integer` - example: `5`
      - `average_rating`: `number(double)` - example: `4.5`
      - `reviews`: `array<object>`
- **404** - Transport not found
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Transport not found.`
    - `error_code`: `string` - example: `TRANSPORT_404`

---

## Wishlist

_Save and manage favourite products (auth required)_

### `GET /api/v1/wishlist` - My Wishlist

Returns all saved products for the authenticated user.

**operationId:** `getWishlist`  
**Auth:** `bearerAuth` (Bearer token required)  

**Responses:**

- **200** - Wishlist retrieved successfully
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Wishlist retrieved successfully.`
    - `data`: `array<object>`
      - `wishlist_id`: `integer` - example: `3`
      - `product_type`: `string` - example: `tour`
      - `id`: `integer` - example: `11`
      - `title`: `string` - example: `Desert Safari`
      - `slug`: `string` - example: `desert-safari`
      - `price`: `number(double)` - example: `120`
      - `image_url`: `string` - example: `/uploads/tours/features/img.jpg`
- **401** - Unauthenticated

---

### `POST /api/v1/wishlist` - Add to Wishlist

Save a product to the authenticated user's wishlist. Returns 409 if already saved.

**operationId:** `addToWishlist`  
**Auth:** `bearerAuth` (Bearer token required)  

**Request Body:**

- Content-Type: `application/json`
- `product_type` **required**: `string enum=['tour', 'hotel', 'activity', 'transport', 'visa']` - example: `tour`
- `product_id` **required**: `integer` - example: `11`

**Responses:**

- **201** - Added to wishlist
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Added to wishlist.`
    - `data`: `object`
      - `wishlist_id`: `integer` - example: `3`
      - `product_type`: `string` - example: `tour`
      - `id`: `integer` - example: `11`
      - `title`: `string` - example: `Desert Safari`
      - `slug`: `string` - example: `desert-safari`
      - `price`: `number(double)` - example: `120`
      - `image_url`: `string`
- **401** - Unauthenticated
- **404** - Product not found
- **409** - Already in wishlist
- **422** - Validation error

---

### `DELETE /api/v1/wishlist/{id}` - Remove from Wishlist

Delete a wishlist entry by its ID.

**operationId:** `removeFromWishlist`  
**Auth:** `bearerAuth` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `id` | `integer` | YES | Wishlist entry ID |

**Responses:**

- **200** - Removed from wishlist
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Removed from wishlist.`
    - `data`: `null`
- **401** - Unauthenticated
- **404** - Wishlist entry not found

---

## Bookings

_Create, view, cancel bookings and download invoices (auth required)_

### `GET /api/v1/bookings` - List My Bookings

Returns the authenticated user's bookings filtered by `status`.

**Status mapping:**
| Query value | Internal statuses |
|------------|-------------------|
| `upcoming` (default) | 1 (Pending), 2 (Processing) |
| `completed` | 3 (Approved) |
| `cancelled` | 4 (Cancelled) |

`is_cancellable` is `true` when status is `upcoming`.

**operationId:** `bookingIndex`  
**Auth:** `bearerAuth` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `status` | `string enum=['upcoming', 'completed', 'cancelled']` |  | Filter bookings by lifecycle status |

**Responses:**

- **200** - Booking list
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Bookings retrieved successfully.`
    - `data`: `array<object>`
      - `id`: `string` - example: `55`
      - `reference_id`: `string` - example: `TRV-5F3A2B`
      - `title`: `string` - example: `Desert Safari Experience`
      - `date`: `string(date)` - example: `2025-07-15`
      - `status`: `string enum=['upcoming', 'completed', 'cancelled']` - example: `upcoming`
      - `payment_status`: `string enum=['paid', 'unpaid']` - example: `unpaid`
      - `total_price`: `number(double)` - example: `735`
      - `currency`: `string` - example: `USD`
      - `is_cancellable`: `boolean` - example: `True`
- **401** - Unauthenticated

---

### `POST /api/v1/bookings` - Create Booking

Create a new booking for a tour, hotel, activity, or transport.

**Price calculation:**
- `adult_total = adult_price × adult_qty × days` (days=1 unless product_type=hotel)
- `child_total = child_price × child_qty`
- `total_amount = adult_total + child_total`
- `tax = total_amount × tax_rate / 100` (from system settings)
- `total_with_tax = total_amount + tax`

**Response:** Returns booking summary with `status: pending` and `payment_status: unpaid`.
Next step: call `POST /payments/initiate` with the returned `id`.

**operationId:** `bookingStore`  
**Auth:** `bearerAuth` (Bearer token required)  

**Request Body:**

- Content-Type: `application/json`
- `product_type` **required**: `string enum=['tour', 'hotel', 'activities', 'transports']` - Type of product being booked | example: `tour`
- `product_id` **required**: `integer` - ID of the product | example: `12`
- `start_date` **required**: `string(date)` - Start / check-in date | example: `2025-07-15`
- `end_date`: `string(date)` - End / check-out date (required for hotels, optional otherwise) | example: `2025-07-18`
- `adult_qty` **required**: `integer` - Number of adult guests | example: `2`
- `child_qty`: `integer` - Number of child guests (0 if none) | example: `1`
- `transport_type`: `string` - Mode for transport bookings: car | train | bus | boat | example: `car`
- `first_name` **required**: `string` - Lead guest first name | example: `Ahmed`
- `last_name`: `string` - Lead guest last name | example: `Al-Rashid`
- `phone` **required**: `string` - Contact phone (max 20 chars) | example: `+966501234567`
- `email` **required**: `string(email)` - Contact email | example: `ahmed@example.com`
- `address`: `string` - Guest address (max 500 chars) | example: `123 King Fahd Rd, Riyadh`
- `notes`: `string` - Special requests (max 1000 chars) | example: `Late check-in requested`

**Responses:**

- **201** - Booking created — proceed to payment
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Booking created successfully.`
    - `data`: `object`
      - `id`: `integer` - example: `55`
      - `order_number`: `string` - example: `TRV-5F3A2B`
      - `total_amount`: `number(double)` - example: `700`
      - `tax_amount`: `number(double)` - example: `35`
      - `total_with_tax`: `number(double)` - example: `735`
      - `status`: `string` - example: `pending`
      - `payment_status`: `string` - example: `unpaid`
- **404** - Product not found
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Product not found.`
    - `error_code`: `string` - example: `PRODUCT_404`
- **422** - Validation error
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `The product type field is required.`
    - `error_code`: `string` - example: `VALIDATION_ERROR`
- **401** - Unauthenticated

---

### `GET /api/v1/bookings/{id}` - Get Booking Detail

Returns full booking details for an order belonging to the authenticated user.

**operationId:** `bookingShow`  
**Auth:** `bearerAuth` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `id` | `integer` | YES | Booking (order) ID |

**Responses:**

- **200** - Booking found
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `id`: `string` - example: `55`
      - `order_number`: `string` - example: `TRV-5F3A2B`
      - `product_type`: `string` - example: `tour`
      - `product_id`: `integer` - example: `12`
      - `product_title`: `string` - example: `Desert Safari Experience`
      - `transport_type`: `string`
      - `start_date`: `string(date)` - example: `2025-07-15`
      - `end_date`: `string(date)`
      - `days`: `integer` - example: `1`
      - `adult_qty`: `integer` - example: `2`
      - `child_qty`: `integer` - example: `1`
      - `adult_unit_price`: `number(double)` - example: `350`
      - `child_unit_price`: `number(double)` - example: `0`
      - `total_amount`: `number(double)` - example: `700`
      - `tax_amount`: `number(double)` - example: `35`
      - `total_with_tax`: `number(double)` - example: `735`
      - `first_name`: `string` - example: `Ahmed`
      - `last_name`: `string` - example: `Al-Rashid`
      - `phone`: `string` - example: `+966501234567`
      - `email`: `string` - example: `ahmed@example.com`
      - `address`: `string` - example: `123 King Fahd Rd, Riyadh`
      - `notes`: `string` - example: `Late check-in requested`
      - `status`: `string enum=['pending', 'processing', 'completed', 'cancelled']` - example: `pending`
      - `payment_status`: `string enum=['unpaid', 'paid', 'refunded']` - example: `unpaid`
      - `is_cancellable`: `boolean` - example: `True`
      - `created_at`: `string(date)` - example: `2025-04-30`
- **404** - Booking not found or belongs to another user
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Booking not found.`
    - `error_code`: `string` - example: `NOT_FOUND`
- **401** - Unauthenticated

---

### `POST /api/v1/bookings/{id}/cancel` - Cancel Booking

Cancel an `upcoming` booking.

A booking can only be cancelled when its status is `pending` (1) or `processing` (2).
Attempting to cancel a `completed` or already `cancelled` booking returns `400 INVALID_STATUS`.
The optional `reason` is appended to the booking's internal notes.

**operationId:** `bookingCancel`  
**Auth:** `bearerAuth` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `id` | `integer` | YES | Booking ID |

**Request Body:**

- Content-Type: `application/json`
- `reason`: `string` - Optional cancellation reason | example: `Change of travel plans`

**Responses:**

- **200** - Booking cancelled
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Booking cancelled successfully.`
    - `data`: `string`
- **400** - Booking is not in a cancellable state
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `This booking cannot be cancelled.`
    - `error_code`: `string` - example: `INVALID_STATUS`
- **404** - Booking not found
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Booking not found.`
    - `error_code`: `string` - example: `NOT_FOUND`
- **401** - Unauthenticated

---

### `GET /api/v1/bookings/{id}/invoice` - Get Invoice URL

Returns a URL to the booking invoice PDF. The URL can be opened in a WebView or browser.

**operationId:** `bookingInvoice`  
**Auth:** `bearerAuth` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `id` | `integer` | YES | Booking ID |

**Responses:**

- **200** - Invoice URL ready
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Invoice URL generated successfully.`
    - `data`: `object`
      - `invoice_url`: `string` - example: `https://app.travelerplatform.com/bookings/invoice/TRV-5F3A2B`
- **404** - Booking not found
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Booking not found.`
    - `error_code`: `string` - example: `NOT_FOUND`
- **401** - Unauthenticated

---

## Payments

_Payment methods and Paymob payment initiation_

### `GET /api/v1/payments/methods` - Get Payment Methods

Returns active Paymob payment methods available in the app. Public endpoint — no auth needed.

**operationId:** `paymentMethods`  

**Responses:**

- **200** - Payment methods list
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `array<object>`
      - `key`: `string` - Unique method identifier — use this in payment/initiate | example: `card`
      - `display_name`: `string` - example: `Credit / Debit Card`
      - `icon_url`: `string` - example: `/uploads/paymob/card-icon.png`

---

### `POST /api/v1/payments/initiate` - Initiate Payment

Initiates a Paymob payment for an existing order.

**Flow:**
1. Create a booking via `POST /bookings` → get `id`
2. Call this endpoint with that `id` and a `method_key`
3. Receive `payment_url` — open it in a Flutter WebView
4. Paymob redirects back; the server webhook updates `payment_status`

Returns `409` if the order is already paid.
Returns `502` if the Paymob gateway fails.

**operationId:** `paymentInitiate`  
**Auth:** `bearerAuth` (Bearer token required)  

**Request Body:**

- Content-Type: `application/json`
- `order_id` **required**: `integer` - ID returned from POST /bookings | example: `55`
- `method_key` **required**: `string` - Payment method key from GET /payments/methods | example: `card`

**Responses:**

- **200** - Payment intent created — open payment_url in WebView
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Payment initiated successfully.`
    - `data`: `object`
      - `order_id`: `integer` - example: `55`
      - `order_number`: `string` - example: `TRV-5F3A2B`
      - `amount`: `number(double)` - example: `735`
      - `client_secret`: `string` - example: `cs_abc123xyz`
      - `public_key`: `string` - example: `pk_test_XXXX`
      - `payment_url`: `string` - example: `https://ksa.paymob.com/unifiedcheckout/?publicKey=pk_test_XXXX&clientSecret=cs_abc123xyz`
      - `method_key`: `string` - example: `card`
- **409** - Order already paid
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `This order is already paid.`
    - `error_code`: `string` - example: `ALREADY_PAID`
- **400** - Payment method not available
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Payment method not available.`
    - `error_code`: `string` - example: `METHOD_UNAVAILABLE`
- **404** - Order not found
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Order not found.`
    - `error_code`: `string` - example: `ORDER_404`
- **502** - Paymob gateway error
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Payment initiation failed.`
    - `error_code`: `string` - example: `PAYMENT_FAILED`
- **401** - Unauthenticated
- **422** - Validation error
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `The method key field is required.`
    - `error_code`: `string` - example: `VALIDATION_ERROR`

---

## Reviews

_Submit product reviews (auth required)_

### `POST /api/v1/reviews` - Submit Review

Submit a review for a tour, hotel, activity, or transport.

- Each user can only review a given product **once** — submitting again returns `409 REVIEW_EXISTS`.
- Rating must be between 1 and 5.
- Review text must be between 10 and 1000 characters.
- Newly created reviews have `status=1` (approved immediately).

**operationId:** `reviewStore`  
**Auth:** `bearerAuth` (Bearer token required)  

**Request Body:**

- Content-Type: `application/json`
- `product_type` **required**: `string enum=['tour', 'hotel', 'activities', 'transport']` - Type of product being reviewed | example: `tour`
- `product_id` **required**: `integer` - ID of the product | example: `12`
- `rating` **required**: `number(double)` - Rating score 1–5 | example: `4.5`
- `review` **required**: `string` - Written review text | example: `Amazing experience! Highly recommend the desert safari to anyone visiting Dubai.`

**Responses:**

- **201** - Review submitted
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Review submitted successfully`
    - `data`: `object`
      - `id`: `integer` - example: `99`
      - `rating`: `number(double)` - example: `4.5`
      - `review`: `string` - example: `Amazing experience!`
      - `created_at`: `string(date)` - example: `2025-04-30`
- **409** - Already reviewed this product
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `You have already reviewed this item.`
    - `error_code`: `string` - example: `REVIEW_EXISTS`
- **422** - Validation error
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `The rating must be at least 1.`
    - `error_code`: `string` - example: `VALIDATION_ERROR`
- **401** - Unauthenticated

---

## Profile

_View and update authenticated user profile and avatar_

### `GET /api/v1/profile` - Get Profile

Returns the authenticated user's public profile fields. Response is a *flat* object (no `success/data` wrapper).

**operationId:** `profileShow`  
**Auth:** `bearerAuth` (Bearer token required)  

**Responses:**

- **200** - Profile data
  - schema (`application/json`):
    - `id`: `string` - example: `42`
    - `name`: `string` - example: `Ahmed Ali`
    - `email`: `string(email)` - example: `ahmed@example.com`
    - `phone`: `string` - example: `+966501234567`
    - `avatar_url`: `string` - example: `/uploads/users/avatar.jpg`
- **401** - Unauthenticated

---

### `PUT /api/v1/profile` - Update Profile

Update the authenticated user's name and phone number. The name is split into `fname` + `lname` internally.

**operationId:** `profileUpdate`  
**Auth:** `bearerAuth` (Bearer token required)  

**Request Body:**

- Content-Type: `application/json`
- `name` **required**: `string` - Full name (max 255 chars) | example: `Ahmed Mohammed`
- `phone` **required**: `string` - Phone number (max 20 chars) | example: `+966509876543`

**Responses:**

- **200** - Profile updated
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Profile updated successfully.`
    - `data`: `object`
      - `id`: `string` - example: `42`
      - `name`: `string` - example: `Ahmed Mohammed`
      - `phone`: `string` - example: `+966509876543`
- **400** - Validation error
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `The name field is required.`
    - `error_code`: `string` - example: `VALIDATION_ERROR`
- **401** - Unauthenticated

---

### `POST /api/v1/profile/avatar` - Upload Avatar

Upload a new profile picture (replaces the existing one).

**Accepted formats:** jpg, jpeg, png
**Max size:** 2 MB (2048 KB)
**Content-Type:** `multipart/form-data`

The old file is deleted from storage automatically.

**operationId:** `profileUploadAvatar`  
**Auth:** `bearerAuth` (Bearer token required)  

**Request Body:**

- Content-Type: `multipart/form-data`
- `file` **required**: `string(binary)` - Image file (jpg/jpeg/png, max 2 MB)

**Responses:**

- **200** - Avatar uploaded
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Avatar uploaded successfully.`
    - `data`: `object`
      - `avatar_url`: `string` - example: `https://app.travelerplatform.com/storage/users/avatar_abc123.jpg`
- **400** - File missing, wrong type, or exceeds size limit
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `The file must be an image. / No file uploaded.`
    - `error_code`: `string` - example: `VALIDATION_ERROR`
- **401** - Unauthenticated

---

## Wallet

_Wallet balance, transactions, deposits and top-up (auth required)_

### `GET /api/v1/wallet` - Get Wallet Balance

Returns the authenticated user's wallet summary.

- `balance` — current spendable balance (from `users.wallet_balance`)
- `total_deposited` — sum of all **completed** deposits (type=1, status=2)
- `total_spent` — sum of all **completed** spending transactions (type=2, status=2)
- Currency is always `SAR`

**operationId:** `walletIndex`  
**Auth:** `bearerAuth` (Bearer token required)  

**Responses:**

- **200** - Wallet summary
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `balance`: `number(double)` - example: `1250.5`
      - `total_deposited`: `number(double)` - example: `3000`
      - `total_spent`: `number(double)` - example: `1749.5`
      - `currency`: `string` - example: `SAR`
- **401** - Unauthenticated

---

### `GET /api/v1/wallet/transactions` - List Wallet Transactions

Paginated list of all wallet transactions (deposits, payments, withdrawals).

**Transaction types:**
| `type` query | Internal value | Description |
|-------------|----------------|-------------|
| `1` | deposit | Money added to wallet |
| `2` | booking_payment | Wallet used to pay for booking |
| `4` | withdrawal | Withdrawal request |

**Status values:** `pending` · `completed` · `failed`

**operationId:** `walletTransactions`  
**Auth:** `bearerAuth` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `type` | `integer enum=[1, 2, 4]` |  | Filter by transaction type (1=deposit, 2=payment, 4=withdrawal) |
| query | `page` | `integer` |  | Page number (default: 1) |
| query | `per_page` | `integer` |  | Items per page (default: 15) |

**Responses:**

- **200** - Transaction list
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `items`: `array<object>`
        - `id`: `integer` - example: `7`
        - `type`: `string enum=['deposit', 'booking_payment', 'withdrawal', 'other']` - example: `deposit`
        - `amount`: `number(double)` - example: `500`
        - `total_amount`: `number(double)` - example: `500`
        - `payment_method`: `string` - example: `card`
        - `transaction_id`: `string` - example: `PAY-TXN-9876`
        - `details`: `string` - example: `Wallet Top-up`
        - `status`: `string enum=['pending', 'completed', 'failed']` - example: `completed`
        - `currency`: `string` - example: `SAR`
        - `created_at`: `string(date)` - example: `2025-04-10`
      - `meta`: `object`
        - `current_page`: `integer` - example: `1`
        - `per_page`: `integer` - example: `15`
        - `total`: `integer` - example: `23`
        - `has_more`: `boolean` - example: `True`
- **401** - Unauthenticated

---

### `GET /api/v1/wallet/deposits` - List Wallet Deposits

Paginated list of deposit-only transactions (type=1). Subset of `/wallet/transactions?type=1`.

**operationId:** `walletDeposits`  
**Auth:** `bearerAuth` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `page` | `integer` |  | Page number (default: 1) |
| query | `per_page` | `integer` |  | Items per page (default: 15) |

**Responses:**

- **200** - Deposit list
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `items`: `array<object>`
        - `id`: `integer` - example: `7`
        - `amount`: `number(double)` - example: `500`
        - `total_amount`: `number(double)` - example: `500`
        - `payment_method`: `string` - example: `card`
        - `transaction_id`: `string` - example: `PAY-TXN-9876`
        - `status`: `string enum=['pending', 'completed', 'failed']` - example: `completed`
        - `currency`: `string` - example: `SAR`
        - `created_at`: `string(date)` - example: `2025-04-10`
      - `meta`: `object`
        - `current_page`: `integer` - example: `1`
        - `per_page`: `integer` - example: `15`
        - `total`: `integer` - example: `8`
        - `has_more`: `boolean` - example: `False`
- **401** - Unauthenticated

---

### `POST /api/v1/wallet/deposit/initiate` - Initiate Wallet Top-Up

Initiates a Paymob payment to top up the wallet balance.

**Flow:**
1. Call this endpoint with `amount` (SAR) and `method_key`
2. A pending wallet record is created (`wallet_id` in response)
3. Open `payment_url` in a Flutter WebView
4. On Paymob callback: wallet balance is credited and record status → `completed`

Amount must be at least 1 SAR.
Returns `502` if the Paymob gateway fails (pending record is deleted).

**operationId:** `walletDepositInitiate`  
**Auth:** `bearerAuth` (Bearer token required)  

**Request Body:**

- Content-Type: `application/json`
- `amount` **required**: `number(double)` - Amount to deposit in SAR | example: `500`
- `method_key` **required**: `string` - Payment method key from GET /payments/methods | example: `card`

**Responses:**

- **200** - Deposit intent created — open payment_url in WebView
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Deposit initiated successfully.`
    - `data`: `object`
      - `wallet_id`: `integer` - ID of the pending wallet record | example: `14`
      - `amount`: `number(double)` - example: `500`
      - `client_secret`: `string` - example: `cs_wallet_abc123`
      - `public_key`: `string` - example: `pk_test_XXXX`
      - `payment_url`: `string` - example: `https://ksa.paymob.com/unifiedcheckout/?publicKey=pk_test_XXXX&clientSecret=cs_wallet_abc123`
- **400** - Payment method not available
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Payment method not available.`
    - `error_code`: `string` - example: `METHOD_UNAVAILABLE`
- **502** - Paymob gateway error — deposit record rolled back
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Payment initiation failed.`
    - `error_code`: `string` - example: `PAYMENT_FAILED`
- **401** - Unauthenticated
- **422** - Validation error
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `The amount must be at least 1.`
    - `error_code`: `string` - example: `VALIDATION_ERROR`

---

## Account / Devices

_Account / Devices_

### `GET /api/v1/account/devices` - List my registered devices

Returns every device the authenticated user has registered, ordered by `last_used_at` desc. The actual `fcm_token` is never returned — only metadata.

**operationId:** `listMyDevices`  
**Auth:** `sanctum` (Bearer token required)  

**Responses:**

- **200** - Device list.
  - schema (`application/json`):
    - `data`: `object`
      - `items`: `array<object>`
        - `id`: `string` - example: `1`
        - `platform`: `string` - example: `android`
        - `device_id`: `string` - example: `emulator-5554`
        - `app_version`: `string` - example: `1.0.0`
        - `last_used_at`: `string(date-time)`
        - `created_at`: `string(date-time)`
- **401** - Unauthenticated.

---

### `POST /api/v1/account/devices` - Register (or upsert) the current device's FCM token

Stores the FCM token issued to the client by `firebase.messaging.getToken()`
so the backend can target this device with push notifications
(e.g. `EsimReadyNotification`).

Behavior:
  * If the same `fcm_token` is already registered to **another user**
    (e.g. logout + login on a shared device), it is **reassigned**
    to the current user — no duplicates.
  * `last_used_at` is bumped to `now()` on every successful call.

Call this:
  * After login.
  * After Firebase rotates/refreshes the token (`onTokenRefresh`).
  * Periodically on app cold-start (helpful for keeping
    `last_used_at` accurate so admins can prune stale devices).

**operationId:** `registerDevice`  
**Auth:** `sanctum` (Bearer token required)  

**Request Body:**

- Content-Type: `application/json`
- `fcm_token` **required**: `string` - FCM registration token from `getToken()`. | example: `fGxN8vQ_xyz:APA91bH...`
- `platform` **required**: `string enum=['ios', 'android', 'web']` - example: `android`
- `device_id`: `string` - Optional vendor identifier (e.g. Android ID, iOS identifierForVendor). | example: `emulator-5554`
- `app_version`: `string` - example: `1.0.0`
- `locale`: `string` - example: `en`

**Responses:**

- **201** - Device registered (created or upserted).
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Device registered.`
    - `data`: `object`
      - `id`: `string` - example: `1`
      - `platform`: `string` - example: `android`
      - `device_id`: `string` - example: `emulator-5554`
- **401** - Unauthenticated.
- **422** - Validation error.

---

### `DELETE /api/v1/account/devices` - Unregister an FCM token

Removes the given FCM token from the database. The match is scoped to the **authenticated user** (`user_id = auth()->id()`), so a user cannot unregister another user's device. Call this on logout or when Firebase reports the token as invalid.

**operationId:** `unregisterDevice`  
**Auth:** `sanctum` (Bearer token required)  

**Request Body:**

- Content-Type: `application/json`
- `fcm_token` **required**: `string` - example: `fGxN8vQ_xyz:APA91bH...`

**Responses:**

- **200** - Deletion result.
  - schema (`application/json`):
    - `data`: `object`
      - `deleted`: `integer` - Number of rows deleted (0 if the token was not yours / not found). | example: `1`
- **401** - Unauthenticated.
- **422** - Validation error.

---

## eSIM (Authenticated)

_eSIM (Authenticated)_

### `POST /api/v1/esim/checkout` - Initiate eSIM checkout (creates order + Paymob payment intention)

Performs the **first half** of the purchase flow:

1. Validates the package and selected payment method.
2. Creates an `EsimOrder` row with `payment_status = pending`,
   `provision_status = awaiting`, and a unique `order_number`
   (format `ESM-XXXXXXXXXX`).
3. Calls Paymob's `/api/intention/create` with the order amount
   (in **piasters** — i.e. price × 100), customer billing data,
   and the chosen `integration_id`.
4. Extracts the `payment_keys[0].key` from the Paymob response and
   builds the iframe URL.

The client is expected to **redirect / open the `payment_iframe` URL**
in a WebView. After the user pays, Paymob will:
  * call our backend `/payment/paymob/webhook` (HMAC verified) to
    mark the order as paid and dispatch `ProvisionEsimJob`,
  * redirect the user to `/esim/thank-you/{orderNumber}` which
    self-refreshes until provisioning completes.

On Paymob failure the order row is kept (with `payment_status = failed`
and `failure_reason` set) so the admin can retry.

**operationId:** `esimCheckout`  
**Auth:** `sanctum` (Bearer token required)  

**Request Body:**

- Content-Type: `application/json`
- `package_id` **required**: `string` - Airalo package id (must exist in `esim_packages` and be active). | example: `burj-mobile-7days-1gb`
- `quantity`: `integer` - Number of identical eSIM profiles to provision (1–10). | example: `1`
- `method_key` **required**: `string` - `paymob_methods.method_key` (e.g. `card`, `wallet`, `valu`). Must be active. | example: `card`
- `email`: `string(email)` - Optional override; defaults to the authenticated user's email. | example: `user@example.com`

**Responses:**

- **201** - Order created; payment iframe ready to open.
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Checkout initiated.`
    - `data`: `object`
      - `order_number`: `string` - example: `ESM-FN5KY6IQKH`
      - `order_id`: `string` - example: `42`
      - `amount`: `number(float)` - example: `5.18`
      - `currency`: `string` - example: `USD`
      - `payment_token`: `string` - Raw Paymob payment key (the iframe consumes this). | example: `ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNkprcFhWQ0o5...`
      - `payment_iframe`: `string` - Full iframe URL — open in a WebView. | example: `https://ksa.paymob.com/api/acceptance/iframes/12490?payment_token=...`
      - `merchant_ref`: `string` - Reference echoed back by Paymob. Format `ESM-{id}-{ts}`. | example: `ESM-42-1733851234`
      - `expires_hint_at`: `string(date-time)` - Soft hint (~30 minutes). Paymob has its own session limits. | example: `2026-05-04T16:30:00+00:00`
- **401** - Unauthenticated.
- **404** - Package or payment method not found.
  - schema (`application/json`):
    - `error_code`: `string enum=['ESIM_PACKAGE_404', 'PAYMENT_METHOD_404']` - example: `ESIM_PACKAGE_404`
- **422** - Validation error.
- **502** - Paymob upstream error.
  - schema (`application/json`):
    - `message`: `string` - example: `Payment initiation failed.`
    - `error_code`: `string` - example: `PAYMENT_INIT_FAILED`

---

### `GET /api/v1/esim/profiles` - List my eSIM profiles

Returns the authenticated user's eSIM profiles (paginated, newest first). Sensitive fields like `qr_code_data` and `matching_id` are NOT included here — fetch a single profile via `/esim/profiles/{iccid}` to get them.

**operationId:** `esimMyProfiles`  
**Auth:** `sanctum` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `per_page` | `integer` |  | Items per page (max 50). |
| query | `page` | `integer` |  |  |

**Responses:**

- **200** - Profile list.
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `data`: `object`
      - `items`: `array<EsimProfileCard>`
      - `meta`: `object`
        - `current_page`: `integer` - example: `1`
        - `last_page`: `integer` - example: `1`
        - `per_page`: `integer` - example: `20`
        - `total`: `integer` - example: `1`
        - `has_more`: `boolean` - example: `False`
- **401** - Unauthenticated.

---

### `GET /api/v1/esim/orders` - List my eSIM orders

Returns the authenticated user's orders (paginated, newest first). Each item includes a summary with `payment_status`, `provision_status`, totals, and `profiles_count`. Use `/esim/orders/{orderNumber}` for the full detail of one order.

**operationId:** `esimMyOrders`  
**Auth:** `sanctum` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `per_page` | `integer` |  |  |
| query | `page` | `integer` |  |  |

**Responses:**

- **200** - Order list.
  - schema (`application/json`):
    - `data`: `object`
      - `items`: `array<object>`
        - `order_number`: `string` - example: `ESM-FN5KY6IQKH`
        - `package_title`: `string` - example: `1 GB - 7 days`
        - `country_code`: `string` - example: `AE`
        - `quantity`: `integer` - example: `1`
        - `total_amount`: `number(float)` - example: `5.18`
        - `currency`: `string` - example: `USD`
        - `payment_status`: `string enum=['pending', 'paid', 'failed', 'refunded']` - example: `paid`
        - `provision_status`: `string enum=['awaiting', 'provisioning', 'completed', 'failed']` - example: `completed`
        - `profiles_count`: `integer` - example: `1`
        - `created_at`: `string(date-time)` - example: `2026-05-03T20:26:50+00:00`
      - `meta`: `object`
- **401** - Unauthenticated.

---

### `GET /api/v1/esim/orders/{orderNumber}` - Get a single order (full detail)

Returns the full details of one order owned by the authenticated user. Each profile in the response only includes `iccid` and `status` — to obtain the QR code, fetch `/esim/profiles/{iccid}` (sensitive fields are isolated to that endpoint).

**operationId:** `esimMyOrderShow`  
**Auth:** `sanctum` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `orderNumber` | `string` | YES | Order number (e.g. `ESM-FN5KY6IQKH`). |

**Responses:**

- **200** - Order detail.
  - schema (`application/json`):
    - `data`: `object`
      - `order_number`: `string`
      - `payment_status`: `string enum=['pending', 'paid', 'failed', 'refunded']`
      - `provision_status`: `string enum=['awaiting', 'provisioning', 'completed', 'failed']`
      - `package_title`: `string`
      - `country_code`: `string`
      - `quantity`: `integer`
      - `unit_price`: `number(float)`
      - `total_amount`: `number(float)`
      - `currency`: `string`
      - `profiles_count`: `integer`
      - `profiles`: `array<object>`
        - `iccid`: `string` - example: `8900000846867436787`
        - `status`: `string enum=['issued', 'installed', 'active', 'expired']` - example: `issued`
      - `failure_reason`: `string`
      - `paid_at`: `string(date-time)`
      - `provisioned_at`: `string(date-time)`
      - `created_at`: `string(date-time)`
- **401** - Unauthenticated.
- **404** - Order not found or not owned by user.
  - schema (`application/json`):
    - `error_code`: `string` - example: `ESIM_ORDER_404`

---

### `GET /api/v1/esim/profiles/{iccid}` - Get a single eSIM profile (with QR code data)

Returns the full profile detail **including** the sensitive fields
`qr_code_data`, `qr_code_url`, and `matching_id` that are required
to install the eSIM on the phone (LPA scheme):

```
qr_code_data → LPA:1$lpa.airalo.com$DUMMY-2603290200-45zZh-84157
```

These fields are kept off the list endpoint and only exposed here,
scoped to the owner.

**operationId:** `esimMyProfileShow`  
**Auth:** `sanctum` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `iccid` | `string` | YES | Integrated Circuit Card ID — alphanumeric. |

**Responses:**

- **200** - Profile detail.
  - schema (`application/json`):
    - _ref -> EsimProfileDetail_
- **401** - Unauthenticated.
- **404** - Profile not found or not owned by user.
  - schema (`application/json`):
    - `error_code`: `string` - example: `ESIM_PROFILE_404`

---

### `POST /api/v1/esim/profiles/{iccid}/refresh-usage` - Force a fresh data-usage pull from Airalo

Bypasses any local cache and asks Airalo's API for the most
up-to-date usage of the given profile. The fresh values are
persisted to `data_used_mb` / `data_remaining_mb` on our side and
returned in the response.

Rate-limited indirectly by Airalo's upstream limits — call
sparingly (e.g. on user pull-to-refresh, not on every screen open).

**operationId:** `esimMyProfileRefreshUsage`  
**Auth:** `sanctum` (Bearer token required)  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `iccid` | `string` | YES |  |

**Responses:**

- **200** - Refreshed usage.
  - schema (`application/json`):
    - `data`: `object`
      - `iccid`: `string`
      - `data_used_mb`: `integer`
      - `data_remaining_mb`: `integer`
      - `status`: `string`
      - `last_synced_at`: `string(date-time)`
- **401** - Unauthenticated.
- **404** - Profile not found.
  - schema (`application/json`):
    - `error_code`: `string` - example: `ESIM_PROFILE_404`
- **502** - Airalo upstream error.
  - schema (`application/json`):
    - `error_code`: `string` - example: `AIRALO_UPSTREAM`

---

## eSIM (Browse)

_eSIM (Browse)_

### `GET /api/v1/esim/countries` - List countries that have at least one local eSIM package

Returns countries grouped from active **local-type** packages, with
aggregate stats per country (count + min/max retail price). Result
is cached for 5 minutes (`esim:countries`). Country names are
resolved through PHP's `Locale::getDisplayRegion()` (intl extension)
with a local fallback table; the response always includes a
ready-to-use flag URL from flagcdn.

**operationId:** `esimCountries`  

**Responses:**

- **200** - Countries list.
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `message`: `string` - example: `Operation successful`
    - `data`: `object`
      - `items`: `array<object>`
        - `code`: `string` - ISO 3166-1 alpha-2 (uppercase). | example: `AE`
        - `name`: `string` - Localized country name. | example: `United Arab Emirates`
        - `flag_url`: `string` - example: `https://flagcdn.com/w80/ae.png`
        - `packages_count`: `integer` - example: `12`
        - `min_price`: `number(float)` - example: `5.18`
        - `max_price`: `number(float)` - example: `89.7`

---

### `GET /api/v1/esim/regions` - List regional and global package groups

Returns groups for **regional** + **global** packages (e.g.
`eu-plus-uk`, `africa-safari`, `world`) with aggregate stats per
slug. Cached for 5 minutes (`esim:regions`). Use the `slug` value
to filter `/esim/packages?type=regional&region={slug}`.

**operationId:** `esimRegions`  

**Responses:**

- **200** - Region groups list.
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `data`: `object`
      - `items`: `array<object>`
        - `type`: `string enum=['regional', 'global']` - example: `regional`
        - `slug`: `string` - Lowercase, hyphenated. | example: `africa-safari`
        - `name`: `string` - Title-cased display name. | example: `Africa Safari`
        - `packages_count`: `integer` - example: `11`
        - `min_price`: `number(float)` - example: `6.9`
        - `max_price`: `number(float)` - example: `136.85`

---

### `GET /api/v1/esim/packages` - List eSIM packages (filterable + sortable + paginated)

Returns active packages. Filters can be combined freely.

**Pricing**: `price` is the user-facing **retail** price (already
includes the configured markup). `data_amount_mb = -1` is the
**sentinel** for unlimited plans — clients should display the
`data_label` field instead.

**operationId:** `esimPackagesIndex`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| query | `country` | `string` |  | ISO 3166-1 alpha-2 (case-insensitive). |
| query | `region` | `string` |  | Region slug from /esim/regions (e.g. `africa-safari`, `world`). |
| query | `type` | `string enum=['local', 'regional', 'global']` |  | Filter by type. |
| query | `q` | `string` |  | Free-text search across `title` and `operator_title`. |
| query | `min_days` | `integer` |  | Minimum validity (inclusive). |
| query | `max_days` | `integer` |  | Maximum validity (inclusive). |
| query | `unlimited_only` | `boolean` |  | If truthy, returns only unlimited (`data_amount_mb = -1`) plans. |
| query | `sort` | `string enum=['price_asc', 'price_desc', 'days_asc', 'days_desc', 'data_desc']` |  | Sort key. |
| query | `per_page` | `integer` |  | Items per page (clamped to 50). |
| query | `page` | `integer` |  | Page index, 1-based. |

**Responses:**

- **200** - Paginated package list.
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `data`: `object`
      - `items`: `array<EsimPackageCard>`
      - `meta`: `object`
        - `current_page`: `integer` - example: `1`
        - `last_page`: `integer` - example: `3`
        - `per_page`: `integer` - example: `5`
        - `total`: `integer` - example: `12`
        - `has_more`: `boolean` - example: `True`

---

### `GET /api/v1/esim/packages/{packageId}` - Get a single eSIM package by Airalo ID

Returns the full detail object (card fields + voice/text/slug). Returns 404 if the package is missing or inactive.

**operationId:** `esimPackagesShow`  

**Parameters:**

| In | Name | Type | Required | Description |
|---|---|---|---|---|
| path | `packageId` | `string` | YES | Airalo package id (kebab-case, e.g. `burj-mobile-7days-1gb`). Pattern: `[A-Za-z0-9_\-]+`. |

**Responses:**

- **200** - Package details.
  - schema (`application/json`):
    - `success`: `boolean` - example: `True`
    - `data`: `EsimPackageDetail`
- **404** - Package not found or inactive.
  - schema (`application/json`):
    - `success`: `boolean` - example: `False`
    - `message`: `string` - example: `Package not found.`
    - `error_code`: `string` - example: `ESIM_PACKAGE_404`

---

## Reusable Schemas

### `EsimProfileCard`

- `iccid`: `string` - example: `8900000846867436787`
- `order_number`: `string` - example: `ESM-FN5KY6IQKH`
- `package_title`: `string` - example: `1 GB - 7 days`
- `country_code`: `string` - example: `AE`
- `data_used_mb`: `integer` - example: `0`
- `data_remaining_mb`: `integer`
- `status`: `string enum=['issued', 'installed', 'active', 'expired']` - example: `issued`
- `expires_at`: `string(date-time)` - example: `2026-05-10T20:27:06+00:00`
- `is_expired`: `boolean` - example: `False`

### `EsimProfileDetail`


### `EsimPackageCard`

- `id`: `string` - example: `burj-mobile-7days-1gb`
- `title`: `string` - example: `1 GB - 7 days`
- `type`: `string enum=['local', 'regional', 'global']` - example: `local`
- `country`: `object`
  - `code`: `string` - example: `AE`
  - `name`: `string` - example: `United Arab Emirates`
  - `flag_url`: `string` - example: `https://flagcdn.com/w80/ae.png`
- `region_slug`: `string` - example: `united-arab-emirates`
- `operator`: `string` - example: `Burj Mobile`
- `data_label`: `string` - Human-readable data amount (`Unlimited`, `1 GB`, `512 MB` ...). | example: `1 GB`
- `data_amount_mb`: `integer` - -1 means Unlimited. | example: `1024`
- `is_unlimited`: `boolean` - example: `False`
- `validity_days`: `integer` - example: `7`
- `price`: `number(float)` - Retail price (after markup). | example: `5.18`
- `currency`: `string` - example: `USD`

### `EsimPackageDetail`

