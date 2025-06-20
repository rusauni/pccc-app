---
title: pccc
language_tabs:
  - shell: Shell
  - http: HTTP
  - javascript: JavaScript
  - ruby: Ruby
  - python: Python
  - php: PHP
  - java: Java
  - go: Go
toc_footers: []
includes: []
search: true
code_clipboard: true
highlight_theme: darkula
headingLevel: 2
generator: "@tarslib/widdershins v4.0.30"

---

# pccc

Base URLs:

# Authentication

* API Key (KeyAuth)
    - Parameter Name: **access_token**, in: query. 

* API Key (Auth)
    - Parameter Name: **Authorization**, in: header. 

# Default

## POST Untitled Endpoint

POST /api/chat

> Response Examples

> 200 Response

```json
{}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

### Responses Data Schema

# Assets

<a id="opIdgetAsset"></a>

## GET Get an Asset

GET /assets/{id}

Image typed files can be dynamically resized and transformed to fit any need.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|string| yes |The id of the file.|
|key|query|string| no |The key of the asset size configured in settings.|
|transforms|query|string| no |A JSON array of image transformations|
|download|query|boolean| no |Download the asset to your computer|

> Response Examples

> 200 Response

```
"string"
```

> 404 Response

```json
{
  "error": {
    "code": 0,
    "message": "string"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|string|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Error: Not found.|Inline|

### Responses Data Schema

HTTP Status Code **404**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

# Items

<a id="opIdreadItemsArticles"></a>

## GET List Items

GET /items/articles

List the articles items.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|meta|query|string| no |What metadata to return in the response.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": 0,
      "status": "string",
      "sort": 0,
      "user_created": "ab6120ca-a162-455c-af0b-743437e6156c",
      "date_created": "string",
      "user_updated": "c26bf67c-3e61-40d1-9cb9-8550c26cadc8",
      "date_updated": "string",
      "title": "string",
      "thumbnail": "dec11f24-4767-4257-ac7d-bde137bc173e",
      "content": null,
      "category": 0,
      "slug": "string",
      "summary": "string",
      "files": "string",
      "tags": "string"
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[ItemsArticles](#schemaitemsarticles)]|false|none||none|
|»» id|integer|false|none||none|
|»» status|string|false|none||none|
|»» sort|integer¦null|false|none||none|
|»» user_created|string(uuid)¦null|false|none||none|
|»» date_created|string(timestamp)¦null|false|none||none|
|»» user_updated|string(uuid)¦null|false|none||none|
|»» date_updated|string(timestamp)¦null|false|none||none|
|»» title|string|true|none||none|
|»» thumbnail|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string(uuid)|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[Files](#schemafiles)|false|none||none|
|»»»» id|string|false|none||Unique identifier for the file.|
|»»»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»»»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»»»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»»»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»»»» type|string|false|none||MIME type of the file.|
|»»»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» created_on|string(date-time)|false|none||When the file was created.|
|»»»» modified_by|string(uuid)¦null|false|none||none|
|»»»» modified_on|string(timestamp)|false|none||none|
|»»»» charset|string¦null|false|none||Character set of the file.|
|»»»» filesize|integer|false|none||Size of the file in bytes.|
|»»»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»»»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»»»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»»»» embed|string¦null|false|none||Where the file was embedded from.|
|»»»» description|string¦null|false|none||Description for the file.|
|»»»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»»»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»»»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»»»» focal_point_x|integer¦null|false|none||none|
|»»»» focal_point_y|integer¦null|false|none||none|
|»»»» tus_id|string¦null|false|none||none|
|»»»» tus_data|null|false|none||none|
|»»»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|»» content|null|false|none||none|
|»» category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» name|string|true|none||none|
|»»»» slug|string¦null|false|none||none|
|»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» name|string|true|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» parent_id|null|false|none||none|
|»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» order|integer|false|none||none|
|»» slug|string¦null|false|none||none|
|»» summary|string¦null|false|none||none|
|»» files|string¦null|false|none||none|
|»» tags|string¦null|false|none||none|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadSingleItemsArticles"></a>

## GET Retrieve an Item

GET /items/articles/{id}

Retrieve a single articles item by unique identifier.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|any| yes |Index of the item.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|
|version|query|string| no |Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.|

#### Description

**version**: Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": 0,
    "status": "string",
    "sort": 0,
    "user_created": "ab6120ca-a162-455c-af0b-743437e6156c",
    "date_created": "string",
    "user_updated": "c26bf67c-3e61-40d1-9cb9-8550c26cadc8",
    "date_updated": "string",
    "title": "string",
    "thumbnail": "dec11f24-4767-4257-ac7d-bde137bc173e",
    "content": null,
    "category": 0,
    "slug": "string",
    "summary": "string",
    "files": "string",
    "tags": "string"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Error: Not found.|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[ItemsArticles](#schemaitemsarticles)|false|none||none|
|»» id|integer|false|none||none|
|»» status|string|false|none||none|
|»» sort|integer¦null|false|none||none|
|»» user_created|string(uuid)¦null|false|none||none|
|»» date_created|string(timestamp)¦null|false|none||none|
|»» user_updated|string(uuid)¦null|false|none||none|
|»» date_updated|string(timestamp)¦null|false|none||none|
|»» title|string|true|none||none|
|»» thumbnail|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string(uuid)|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[Files](#schemafiles)|false|none||none|
|»»»» id|string|false|none||Unique identifier for the file.|
|»»»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»»»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»»»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»»»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»»»» type|string|false|none||MIME type of the file.|
|»»»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» created_on|string(date-time)|false|none||When the file was created.|
|»»»» modified_by|string(uuid)¦null|false|none||none|
|»»»» modified_on|string(timestamp)|false|none||none|
|»»»» charset|string¦null|false|none||Character set of the file.|
|»»»» filesize|integer|false|none||Size of the file in bytes.|
|»»»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»»»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»»»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»»»» embed|string¦null|false|none||Where the file was embedded from.|
|»»»» description|string¦null|false|none||Description for the file.|
|»»»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»»»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»»»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»»»» focal_point_x|integer¦null|false|none||none|
|»»»» focal_point_y|integer¦null|false|none||none|
|»»»» tus_id|string¦null|false|none||none|
|»»»» tus_data|null|false|none||none|
|»»»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|»» content|null|false|none||none|
|»» category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» name|string|true|none||none|
|»»»» slug|string¦null|false|none||none|
|»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» name|string|true|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» parent_id|null|false|none||none|
|»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» order|integer|false|none||none|
|»» slug|string¦null|false|none||none|
|»» summary|string¦null|false|none||none|
|»» files|string¦null|false|none||none|
|»» tags|string¦null|false|none||none|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

HTTP Status Code **404**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadItemsCategories"></a>

## GET List Items

GET /items/categories

List the categories items.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|meta|query|string| no |What metadata to return in the response.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": 0,
      "name": "string",
      "slug": "string",
      "parent_id": 0,
      "order": 0
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[ItemsCategories](#schemaitemscategories)]|false|none||none|
|»» id|integer|false|none||none|
|»» name|string|true|none||none|
|»» slug|string¦null|false|none||none|
|»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» name|string|true|none||none|
|»»»» slug|string¦null|false|none||none|
|»»»» parent_id|null|false|none||none|
|»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» order|integer|false|none||none|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadSingleItemsCategories"></a>

## GET Retrieve an Item

GET /items/categories/{id}

Retrieve a single categories item by unique identifier.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|any| yes |Index of the item.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|
|version|query|string| no |Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.|

#### Description

**version**: Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": 0,
    "name": "string",
    "slug": "string",
    "parent_id": 0,
    "order": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Error: Not found.|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»» id|integer|false|none||none|
|»» name|string|true|none||none|
|»» slug|string¦null|false|none||none|
|»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» name|string|true|none||none|
|»»»» slug|string¦null|false|none||none|
|»»»» parent_id|null|false|none||none|
|»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» order|integer|false|none||none|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

HTTP Status Code **404**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadItemsDocuments"></a>

## GET List Items

GET /items/documents

List the documents items.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|meta|query|string| no |What metadata to return in the response.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": 0,
      "title": "string",
      "file": "00bd29cf-1ab3-4825-b15f-d80a4a0e1cbb",
      "description": "string",
      "category": 0,
      "document_number": "string",
      "effective_date": "2019-08-24",
      "sub_category": 0,
      "agency_id": 0,
      "document_type_id": 0,
      "tags": "string"
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[ItemsDocuments](#schemaitemsdocuments)]|false|none||none|
|»» id|integer|false|none||none|
|»» title|string|true|none||none|
|»» file|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string(uuid)|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[Files](#schemafiles)|false|none||none|
|»»»» id|string|false|none||Unique identifier for the file.|
|»»»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»»»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»»»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»»»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»»»» type|string|false|none||MIME type of the file.|
|»»»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» created_on|string(date-time)|false|none||When the file was created.|
|»»»» modified_by|string(uuid)¦null|false|none||none|
|»»»» modified_on|string(timestamp)|false|none||none|
|»»»» charset|string¦null|false|none||Character set of the file.|
|»»»» filesize|integer|false|none||Size of the file in bytes.|
|»»»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»»»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»»»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»»»» embed|string¦null|false|none||Where the file was embedded from.|
|»»»» description|string¦null|false|none||Description for the file.|
|»»»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»»»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»»»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»»»» focal_point_x|integer¦null|false|none||none|
|»»»» focal_point_y|integer¦null|false|none||none|
|»»»» tus_id|string¦null|false|none||none|
|»»»» tus_data|null|false|none||none|
|»»»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|»» description|string¦null|false|none||none|
|»» category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» name|string|true|none||none|
|»»»» slug|string¦null|false|none||none|
|»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» name|string|true|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» parent_id|null|false|none||none|
|»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» order|integer|false|none||none|
|»» document_number|string¦null|false|none||none|
|»» effective_date|string(date)¦null|false|none||none|
|»» sub_category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsSubCategory](#schemaitemssubcategory)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» sub_name|string¦null|false|none||none|
|»»»» category_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» name|string|true|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» parent_id|null|false|none||none|
|»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» slug|string¦null|false|none||none|
|»» agency_id|null|false|none||Cơ quan ban hành|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsIssuingAgency](#schemaitemsissuingagency)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» agency_name|string¦null|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» document_type_id|null|false|none||Loại văn bản|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsDocumentType](#schemaitemsdocumenttype)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» document_type_name|string¦null|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» tags|string¦null|false|none||none|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadSingleItemsDocuments"></a>

## GET Retrieve an Item

GET /items/documents/{id}

Retrieve a single documents item by unique identifier.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|any| yes |Index of the item.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|
|version|query|string| no |Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.|

#### Description

**version**: Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": 0,
    "title": "string",
    "file": "00bd29cf-1ab3-4825-b15f-d80a4a0e1cbb",
    "description": "string",
    "category": 0,
    "document_number": "string",
    "effective_date": "2019-08-24",
    "sub_category": 0,
    "agency_id": 0,
    "document_type_id": 0,
    "tags": "string"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Error: Not found.|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[ItemsDocuments](#schemaitemsdocuments)|false|none||none|
|»» id|integer|false|none||none|
|»» title|string|true|none||none|
|»» file|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string(uuid)|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[Files](#schemafiles)|false|none||none|
|»»»» id|string|false|none||Unique identifier for the file.|
|»»»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»»»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»»»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»»»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»»»» type|string|false|none||MIME type of the file.|
|»»»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» created_on|string(date-time)|false|none||When the file was created.|
|»»»» modified_by|string(uuid)¦null|false|none||none|
|»»»» modified_on|string(timestamp)|false|none||none|
|»»»» charset|string¦null|false|none||Character set of the file.|
|»»»» filesize|integer|false|none||Size of the file in bytes.|
|»»»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»»»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»»»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»»»» embed|string¦null|false|none||Where the file was embedded from.|
|»»»» description|string¦null|false|none||Description for the file.|
|»»»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»»»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»»»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»»»» focal_point_x|integer¦null|false|none||none|
|»»»» focal_point_y|integer¦null|false|none||none|
|»»»» tus_id|string¦null|false|none||none|
|»»»» tus_data|null|false|none||none|
|»»»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|»» description|string¦null|false|none||none|
|»» category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» name|string|true|none||none|
|»»»» slug|string¦null|false|none||none|
|»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» name|string|true|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» parent_id|null|false|none||none|
|»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» order|integer|false|none||none|
|»» document_number|string¦null|false|none||none|
|»» effective_date|string(date)¦null|false|none||none|
|»» sub_category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsSubCategory](#schemaitemssubcategory)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» sub_name|string¦null|false|none||none|
|»»»» category_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» name|string|true|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» parent_id|null|false|none||none|
|»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» slug|string¦null|false|none||none|
|»» agency_id|null|false|none||Cơ quan ban hành|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsIssuingAgency](#schemaitemsissuingagency)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» agency_name|string¦null|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» document_type_id|null|false|none||Loại văn bản|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsDocumentType](#schemaitemsdocumenttype)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» document_type_name|string¦null|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» tags|string¦null|false|none||none|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

HTTP Status Code **404**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadItemsVideos"></a>

## GET List Items

GET /items/videos

List the videos items.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|meta|query|string| no |What metadata to return in the response.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": 0,
      "title": "string",
      "link": "string",
      "thumbnail": "dec11f24-4767-4257-ac7d-bde137bc173e",
      "description": "string",
      "category": 0,
      "tags": "string"
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[ItemsVideos](#schemaitemsvideos)]|false|none||none|
|»» id|integer|false|none||none|
|»» title|string|true|none||none|
|»» link|string¦null|false|none||none|
|»» thumbnail|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string(uuid)|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[Files](#schemafiles)|false|none||none|
|»»»» id|string|false|none||Unique identifier for the file.|
|»»»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»»»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»»»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»»»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»»»» type|string|false|none||MIME type of the file.|
|»»»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» created_on|string(date-time)|false|none||When the file was created.|
|»»»» modified_by|string(uuid)¦null|false|none||none|
|»»»» modified_on|string(timestamp)|false|none||none|
|»»»» charset|string¦null|false|none||Character set of the file.|
|»»»» filesize|integer|false|none||Size of the file in bytes.|
|»»»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»»»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»»»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»»»» embed|string¦null|false|none||Where the file was embedded from.|
|»»»» description|string¦null|false|none||Description for the file.|
|»»»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»»»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»»»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»»»» focal_point_x|integer¦null|false|none||none|
|»»»» focal_point_y|integer¦null|false|none||none|
|»»»» tus_id|string¦null|false|none||none|
|»»»» tus_data|null|false|none||none|
|»»»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|»» description|string¦null|false|none||none|
|»» category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» name|string|true|none||none|
|»»»» slug|string¦null|false|none||none|
|»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» name|string|true|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» parent_id|null|false|none||none|
|»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» order|integer|false|none||none|
|»» tags|string¦null|false|none||none|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadSingleItemsVideos"></a>

## GET Retrieve an Item

GET /items/videos/{id}

Retrieve a single videos item by unique identifier.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|any| yes |Index of the item.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|
|version|query|string| no |Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.|

#### Description

**version**: Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": 0,
    "title": "string",
    "link": "string",
    "thumbnail": "dec11f24-4767-4257-ac7d-bde137bc173e",
    "description": "string",
    "category": 0,
    "tags": "string"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Error: Not found.|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[ItemsVideos](#schemaitemsvideos)|false|none||none|
|»» id|integer|false|none||none|
|»» title|string|true|none||none|
|»» link|string¦null|false|none||none|
|»» thumbnail|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string(uuid)|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[Files](#schemafiles)|false|none||none|
|»»»» id|string|false|none||Unique identifier for the file.|
|»»»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»»»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»»»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»»»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»»»» type|string|false|none||MIME type of the file.|
|»»»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» created_on|string(date-time)|false|none||When the file was created.|
|»»»» modified_by|string(uuid)¦null|false|none||none|
|»»»» modified_on|string(timestamp)|false|none||none|
|»»»» charset|string¦null|false|none||Character set of the file.|
|»»»» filesize|integer|false|none||Size of the file in bytes.|
|»»»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»»»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»»»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»»»» embed|string¦null|false|none||Where the file was embedded from.|
|»»»» description|string¦null|false|none||Description for the file.|
|»»»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»»»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»»»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»»»» focal_point_x|integer¦null|false|none||none|
|»»»» focal_point_y|integer¦null|false|none||none|
|»»»» tus_id|string¦null|false|none||none|
|»»»» tus_data|null|false|none||none|
|»»»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|»» description|string¦null|false|none||none|
|»» category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» name|string|true|none||none|
|»»»» slug|string¦null|false|none||none|
|»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» name|string|true|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» parent_id|null|false|none||none|
|»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» order|integer|false|none||none|
|»» tags|string¦null|false|none||none|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

HTTP Status Code **404**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadItemsTags"></a>

## GET List Items

GET /items/tags

List the tags items.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|meta|query|string| no |What metadata to return in the response.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": 0,
      "name": "string",
      "slug": "string"
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[ItemsTags](#schemaitemstags)]|false|none||none|
|»» id|integer|false|none||none|
|»» name|string|true|none||none|
|»» slug|string¦null|false|none||none|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadSingleItemsTags"></a>

## GET Retrieve an Item

GET /items/tags/{id}

Retrieve a single tags item by unique identifier.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|any| yes |Index of the item.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|
|version|query|string| no |Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.|

#### Description

**version**: Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": 0,
    "name": "string",
    "slug": "string"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Error: Not found.|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[ItemsTags](#schemaitemstags)|false|none||none|
|»» id|integer|false|none||none|
|»» name|string|true|none||none|
|»» slug|string¦null|false|none||none|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

HTTP Status Code **404**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadItemsSubCategory"></a>

## GET List Items

GET /items/sub_category

List the sub_category items.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|meta|query|string| no |What metadata to return in the response.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": 0,
      "sub_name": "string",
      "category_id": 0,
      "slug": "string"
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[ItemsSubCategory](#schemaitemssubcategory)]|false|none||none|
|»» id|integer|false|none||none|
|»» sub_name|string¦null|false|none||none|
|»» category_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» name|string|true|none||none|
|»»»» slug|string¦null|false|none||none|
|»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» name|string|true|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» parent_id|null|false|none||none|
|»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» order|integer|false|none||none|
|»» slug|string¦null|false|none||none|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadSingleItemsSubCategory"></a>

## GET Retrieve an Item

GET /items/sub_category/{id}

Retrieve a single sub_category item by unique identifier.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|any| yes |Index of the item.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|
|version|query|string| no |Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.|

#### Description

**version**: Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": 0,
    "sub_name": "string",
    "category_id": 0,
    "slug": "string"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Error: Not found.|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[ItemsSubCategory](#schemaitemssubcategory)|false|none||none|
|»» id|integer|false|none||none|
|»» sub_name|string¦null|false|none||none|
|»» category_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» name|string|true|none||none|
|»»»» slug|string¦null|false|none||none|
|»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» name|string|true|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» parent_id|null|false|none||none|
|»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» order|integer|false|none||none|
|»» slug|string¦null|false|none||none|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

HTTP Status Code **404**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadItemsDocumentType"></a>

## GET List Items

GET /items/document_type

List the document_type items.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|meta|query|string| no |What metadata to return in the response.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": 0,
      "document_type_name": "string"
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[ItemsDocumentType](#schemaitemsdocumenttype)]|false|none||none|
|»» id|integer|false|none||none|
|»» document_type_name|string¦null|false|none||none|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadSingleItemsDocumentType"></a>

## GET Retrieve an Item

GET /items/document_type/{id}

Retrieve a single document_type item by unique identifier.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|any| yes |Index of the item.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|
|version|query|string| no |Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.|

#### Description

**version**: Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": 0,
    "document_type_name": "string"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Error: Not found.|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[ItemsDocumentType](#schemaitemsdocumenttype)|false|none||none|
|»» id|integer|false|none||none|
|»» document_type_name|string¦null|false|none||none|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

HTTP Status Code **404**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadItemsIssuingAgency"></a>

## GET List Items

GET /items/issuing_agency

List the issuing_agency items.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|meta|query|string| no |What metadata to return in the response.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": 0,
      "agency_name": "string"
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[ItemsIssuingAgency](#schemaitemsissuingagency)]|false|none||none|
|»» id|integer|false|none||none|
|»» agency_name|string¦null|false|none||none|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadSingleItemsIssuingAgency"></a>

## GET Retrieve an Item

GET /items/issuing_agency/{id}

Retrieve a single issuing_agency item by unique identifier.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|any| yes |Index of the item.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|
|version|query|string| no |Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.|

#### Description

**version**: Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": 0,
    "agency_name": "string"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Error: Not found.|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[ItemsIssuingAgency](#schemaitemsissuingagency)|false|none||none|
|»» id|integer|false|none||none|
|»» agency_name|string¦null|false|none||none|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

HTTP Status Code **404**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadItemsFeaturedArticles"></a>

## GET List Items

GET /items/featured_articles

List the featured_articles items.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|meta|query|string| no |What metadata to return in the response.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": 0,
      "title": "string",
      "articles": [
        0
      ]
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[ItemsFeaturedArticles](#schemaitemsfeaturedarticles)]|false|none||none|
|»» id|integer|false|none||none|
|»» title|string¦null|false|none||none|
|»» articles|[oneOf]¦null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsFeaturedArticlesArticles](#schemaitemsfeaturedarticlesarticles)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» featured_articles_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsFeaturedArticles](#schemaitemsfeaturedarticles)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» title|string¦null|false|none||none|
|»»»»»» articles|[oneOf]¦null|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» articles_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsArticles](#schemaitemsarticles)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» status|string|false|none||none|
|»»»»»» sort|integer¦null|false|none||none|
|»»»»»» user_created|string(uuid)¦null|false|none||none|
|»»»»»» date_created|string(timestamp)¦null|false|none||none|
|»»»»»» user_updated|string(uuid)¦null|false|none||none|
|»»»»»» date_updated|string(timestamp)¦null|false|none||none|
|»»»»»» title|string|true|none||none|
|»»»»»» thumbnail|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|string(uuid)|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|[Files](#schemafiles)|false|none||none|
|»»»»»»»» id|string|false|none||Unique identifier for the file.|
|»»»»»»»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»»»»»»»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»»»»»»»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»»»»»»»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»»»»»»»» type|string|false|none||MIME type of the file.|
|»»»»»»»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»» created_on|string(date-time)|false|none||When the file was created.|
|»»»»»»»» modified_by|string(uuid)¦null|false|none||none|
|»»»»»»»» modified_on|string(timestamp)|false|none||none|
|»»»»»»»» charset|string¦null|false|none||Character set of the file.|
|»»»»»»»» filesize|integer|false|none||Size of the file in bytes.|
|»»»»»»»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»»»»»»»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»»»»»»»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»»»»»»»» embed|string¦null|false|none||Where the file was embedded from.|
|»»»»»»»» description|string¦null|false|none||Description for the file.|
|»»»»»»»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»»»»»»»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»»»»»»»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»»»»»»»» focal_point_x|integer¦null|false|none||none|
|»»»»»»»» focal_point_y|integer¦null|false|none||none|
|»»»»»»»» tus_id|string¦null|false|none||none|
|»»»»»»»» tus_data|null|false|none||none|
|»»»»»»»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|»»»»»» content|null|false|none||none|
|»»»»»» category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»»»» id|integer|false|none||none|
|»»»»»»»» name|string|true|none||none|
|»»»»»»»» slug|string¦null|false|none||none|
|»»»»»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»»»»»» id|integer|false|none||none|
|»»»»»»»»»» name|string|true|none||none|
|»»»»»»»»»» slug|string¦null|false|none||none|
|»»»»»»»»»» parent_id|null|false|none||none|
|»»»»»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»» order|integer|false|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» summary|string¦null|false|none||none|
|»»»»»» files|string¦null|false|none||none|
|»»»»»» tags|string¦null|false|none||none|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadSingleItemsFeaturedArticles"></a>

## GET Retrieve an Item

GET /items/featured_articles/{id}

Retrieve a single featured_articles item by unique identifier.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|any| yes |Index of the item.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|
|version|query|string| no |Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.|

#### Description

**version**: Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": 0,
    "title": "string",
    "articles": [
      0
    ]
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Error: Not found.|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[ItemsFeaturedArticles](#schemaitemsfeaturedarticles)|false|none||none|
|»» id|integer|false|none||none|
|»» title|string¦null|false|none||none|
|»» articles|[oneOf]¦null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsFeaturedArticlesArticles](#schemaitemsfeaturedarticlesarticles)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» featured_articles_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsFeaturedArticles](#schemaitemsfeaturedarticles)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» title|string¦null|false|none||none|
|»»»»»» articles|[oneOf]¦null|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»» articles_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsArticles](#schemaitemsarticles)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» status|string|false|none||none|
|»»»»»» sort|integer¦null|false|none||none|
|»»»»»» user_created|string(uuid)¦null|false|none||none|
|»»»»»» date_created|string(timestamp)¦null|false|none||none|
|»»»»»» user_updated|string(uuid)¦null|false|none||none|
|»»»»»» date_updated|string(timestamp)¦null|false|none||none|
|»»»»»» title|string|true|none||none|
|»»»»»» thumbnail|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|string(uuid)|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|[Files](#schemafiles)|false|none||none|
|»»»»»»»» id|string|false|none||Unique identifier for the file.|
|»»»»»»»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»»»»»»»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»»»»»»»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»»»»»»»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»»»»»»»» type|string|false|none||MIME type of the file.|
|»»»»»»»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»» created_on|string(date-time)|false|none||When the file was created.|
|»»»»»»»» modified_by|string(uuid)¦null|false|none||none|
|»»»»»»»» modified_on|string(timestamp)|false|none||none|
|»»»»»»»» charset|string¦null|false|none||Character set of the file.|
|»»»»»»»» filesize|integer|false|none||Size of the file in bytes.|
|»»»»»»»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»»»»»»»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»»»»»»»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»»»»»»»» embed|string¦null|false|none||Where the file was embedded from.|
|»»»»»»»» description|string¦null|false|none||Description for the file.|
|»»»»»»»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»»»»»»»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»»»»»»»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»»»»»»»» focal_point_x|integer¦null|false|none||none|
|»»»»»»»» focal_point_y|integer¦null|false|none||none|
|»»»»»»»» tus_id|string¦null|false|none||none|
|»»»»»»»» tus_data|null|false|none||none|
|»»»»»»»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|»»»»»» content|null|false|none||none|
|»»»»»» category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»»»» id|integer|false|none||none|
|»»»»»»»» name|string|true|none||none|
|»»»»»»»» slug|string¦null|false|none||none|
|»»»»»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»»»»»» id|integer|false|none||none|
|»»»»»»»»»» name|string|true|none||none|
|»»»»»»»»»» slug|string¦null|false|none||none|
|»»»»»»»»»» parent_id|null|false|none||none|
|»»»»»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»» order|integer|false|none||none|
|»»»»»» slug|string¦null|false|none||none|
|»»»»»» summary|string¦null|false|none||none|
|»»»»»» files|string¦null|false|none||none|
|»»»»»» tags|string¦null|false|none||none|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

HTTP Status Code **404**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadItemsFeaturedArticlesArticles"></a>

## GET List Items

GET /items/featured_articles_articles

List the featured_articles_articles items.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|meta|query|string| no |What metadata to return in the response.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": 0,
      "featured_articles_id": 0,
      "articles_id": 0
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[ItemsFeaturedArticlesArticles](#schemaitemsfeaturedarticlesarticles)]|false|none||none|
|»» id|integer|false|none||none|
|»» featured_articles_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsFeaturedArticles](#schemaitemsfeaturedarticles)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» title|string¦null|false|none||none|
|»»»» articles|[oneOf]¦null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsFeaturedArticlesArticles](#schemaitemsfeaturedarticlesarticles)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» featured_articles_id|null|false|none||none|
|»»»»»» articles_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|[ItemsArticles](#schemaitemsarticles)|false|none||none|
|»»»»»»»» id|integer|false|none||none|
|»»»»»»»» status|string|false|none||none|
|»»»»»»»» sort|integer¦null|false|none||none|
|»»»»»»»» user_created|string(uuid)¦null|false|none||none|
|»»»»»»»» date_created|string(timestamp)¦null|false|none||none|
|»»»»»»»» user_updated|string(uuid)¦null|false|none||none|
|»»»»»»»» date_updated|string(timestamp)¦null|false|none||none|
|»»»»»»»» title|string|true|none||none|
|»»»»»»»» thumbnail|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|string(uuid)|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|[Files](#schemafiles)|false|none||none|
|»»»»»»»»»» id|string|false|none||Unique identifier for the file.|
|»»»»»»»»»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»»»»»»»»»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»»»»»»»»»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»»»»»»»»»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»»»»»»»»»» type|string|false|none||MIME type of the file.|
|»»»»»»»»»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»» created_on|string(date-time)|false|none||When the file was created.|
|»»»»»»»»»» modified_by|string(uuid)¦null|false|none||none|
|»»»»»»»»»» modified_on|string(timestamp)|false|none||none|
|»»»»»»»»»» charset|string¦null|false|none||Character set of the file.|
|»»»»»»»»»» filesize|integer|false|none||Size of the file in bytes.|
|»»»»»»»»»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»»»»»»»»»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»»»»»»»»»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»»»»»»»»»» embed|string¦null|false|none||Where the file was embedded from.|
|»»»»»»»»»» description|string¦null|false|none||Description for the file.|
|»»»»»»»»»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»»»»»»»»»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»»»»»»»»»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»»»»»»»»»» focal_point_x|integer¦null|false|none||none|
|»»»»»»»»»» focal_point_y|integer¦null|false|none||none|
|»»»»»»»»»» tus_id|string¦null|false|none||none|
|»»»»»»»»»» tus_data|null|false|none||none|
|»»»»»»»»»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|»»»»»»»» content|null|false|none||none|
|»»»»»»»» category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»»»»»» id|integer|false|none||none|
|»»»»»»»»»» name|string|true|none||none|
|»»»»»»»»»» slug|string¦null|false|none||none|
|»»»»»»»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»»»»»»»» id|integer|false|none||none|
|»»»»»»»»»»»» name|string|true|none||none|
|»»»»»»»»»»»» slug|string¦null|false|none||none|
|»»»»»»»»»»»» parent_id|null|false|none||none|
|»»»»»»»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»» order|integer|false|none||none|
|»»»»»»»» slug|string¦null|false|none||none|
|»»»»»»»» summary|string¦null|false|none||none|
|»»»»»»»» files|string¦null|false|none||none|
|»»»»»»»» tags|string¦null|false|none||none|
|»» articles_id|null|false|none||none|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdreadSingleItemsFeaturedArticlesArticles"></a>

## GET Retrieve an Item

GET /items/featured_articles_articles/{id}

Retrieve a single featured_articles_articles item by unique identifier.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|any| yes |Index of the item.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|
|version|query|string| no |Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.|

#### Description

**version**: Retrieve an item's state from a specific Content Version. The value corresponds to the "key" of the Content Version.

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": 0,
    "featured_articles_id": 0,
    "articles_id": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Error: Not found.|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[ItemsFeaturedArticlesArticles](#schemaitemsfeaturedarticlesarticles)|false|none||none|
|»» id|integer|false|none||none|
|»» featured_articles_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|[ItemsFeaturedArticles](#schemaitemsfeaturedarticles)|false|none||none|
|»»»» id|integer|false|none||none|
|»»»» title|string¦null|false|none||none|
|»»»» articles|[oneOf]¦null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»» *anonymous*|[ItemsFeaturedArticlesArticles](#schemaitemsfeaturedarticlesarticles)|false|none||none|
|»»»»»» id|integer|false|none||none|
|»»»»»» featured_articles_id|null|false|none||none|
|»»»»»» articles_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»» *anonymous*|[ItemsArticles](#schemaitemsarticles)|false|none||none|
|»»»»»»»» id|integer|false|none||none|
|»»»»»»»» status|string|false|none||none|
|»»»»»»»» sort|integer¦null|false|none||none|
|»»»»»»»» user_created|string(uuid)¦null|false|none||none|
|»»»»»»»» date_created|string(timestamp)¦null|false|none||none|
|»»»»»»»» user_updated|string(uuid)¦null|false|none||none|
|»»»»»»»» date_updated|string(timestamp)¦null|false|none||none|
|»»»»»»»» title|string|true|none||none|
|»»»»»»»» thumbnail|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|string(uuid)|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|[Files](#schemafiles)|false|none||none|
|»»»»»»»»»» id|string|false|none||Unique identifier for the file.|
|»»»»»»»»»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»»»»»»»»»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»»»»»»»»»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»»»»»»»»»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»»»»»»»»»» type|string|false|none||MIME type of the file.|
|»»»»»»»»»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»» created_on|string(date-time)|false|none||When the file was created.|
|»»»»»»»»»» modified_by|string(uuid)¦null|false|none||none|
|»»»»»»»»»» modified_on|string(timestamp)|false|none||none|
|»»»»»»»»»» charset|string¦null|false|none||Character set of the file.|
|»»»»»»»»»» filesize|integer|false|none||Size of the file in bytes.|
|»»»»»»»»»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»»»»»»»»»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»»»»»»»»»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»»»»»»»»»» embed|string¦null|false|none||Where the file was embedded from.|
|»»»»»»»»»» description|string¦null|false|none||Description for the file.|
|»»»»»»»»»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»»»»»»»»»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»»»»»»»»»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»»»»»»»»»» focal_point_x|integer¦null|false|none||none|
|»»»»»»»»»» focal_point_y|integer¦null|false|none||none|
|»»»»»»»»»» tus_id|string¦null|false|none||none|
|»»»»»»»»»» tus_data|null|false|none||none|
|»»»»»»»»»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|»»»»»»»» content|null|false|none||none|
|»»»»»»»» category|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»»»»»» id|integer|false|none||none|
|»»»»»»»»»» name|string|true|none||none|
|»»»»»»»»»» slug|string¦null|false|none||none|
|»»»»»»»»»» parent_id|null|false|none||none|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|integer|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»»» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|
|»»»»»»»»»»»» id|integer|false|none||none|
|»»»»»»»»»»»» name|string|true|none||none|
|»»»»»»»»»»»» slug|string¦null|false|none||none|
|»»»»»»»»»»»» parent_id|null|false|none||none|
|»»»»»»»»»»»» order|integer|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»»»»»»»»» order|integer|false|none||none|
|»»»»»»»» slug|string¦null|false|none||none|
|»»»»»»»» summary|string¦null|false|none||none|
|»»»»»»»» files|string¦null|false|none||none|
|»»»»»»»» tags|string¦null|false|none||none|
|»» articles_id|null|false|none||none|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

HTTP Status Code **404**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

# Files

<a id="opIdgetFiles"></a>

## GET List Files

GET /files

List the files.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|
|meta|query|string| no |What metadata to return in the response.|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": "8cbb43fe-4cdf-4991-8352-c461779cec02",
      "storage": "local",
      "filename_disk": "a88c3b72-ac58-5436-a4ec-b2858531333a.jpg",
      "filename_download": "avatar.jpg",
      "title": "User Avatar",
      "type": "image/jpeg",
      "folder": null,
      "uploaded_by": "63716273-0f29-4648-8a2a-2af2948f6f78",
      "created_on": "2019-12-03T00:10:15+00:00",
      "modified_by": "e8d4374d-93a1-4e98-a6c6-fdcf00c5059f",
      "modified_on": "string",
      "charset": "binary",
      "filesize": 137862,
      "width": 800,
      "height": 838,
      "duration": 0,
      "embed": null,
      "description": "string",
      "location": "string",
      "tags": [
        "string"
      ],
      "metadata": {},
      "focal_point_x": 0,
      "focal_point_y": 0,
      "tus_id": "string",
      "tus_data": null,
      "uploaded_on": "2019-12-03T00:10:15+00:00"
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[Files](#schemafiles)]|false|none||none|
|»» id|string|false|none||Unique identifier for the file.|
|»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»» type|string|false|none||MIME type of the file.|
|»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» created_on|string(date-time)|false|none||When the file was created.|
|»» modified_by|string(uuid)¦null|false|none||none|
|»» modified_on|string(timestamp)|false|none||none|
|»» charset|string¦null|false|none||Character set of the file.|
|»» filesize|integer|false|none||Size of the file in bytes.|
|»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»» embed|string¦null|false|none||Where the file was embedded from.|
|»» description|string¦null|false|none||Description for the file.|
|»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»» focal_point_x|integer¦null|false|none||none|
|»» focal_point_y|integer¦null|false|none||none|
|»» tus_id|string¦null|false|none||none|
|»» tus_data|null|false|none||none|
|»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdcreateFile"></a>

## POST Create a File

POST /files

Create a new file

> Body Parameters

```json
{
  "data": "string"
}
```

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|body|body|object| no |none|
|» data|body|string| no |none|

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": "8cbb43fe-4cdf-4991-8352-c461779cec02",
    "storage": "local",
    "filename_disk": "a88c3b72-ac58-5436-a4ec-b2858531333a.jpg",
    "filename_download": "avatar.jpg",
    "title": "User Avatar",
    "type": "image/jpeg",
    "folder": null,
    "uploaded_by": "63716273-0f29-4648-8a2a-2af2948f6f78",
    "created_on": "2019-12-03T00:10:15+00:00",
    "modified_by": "e8d4374d-93a1-4e98-a6c6-fdcf00c5059f",
    "modified_on": "string",
    "charset": "binary",
    "filesize": 137862,
    "width": 800,
    "height": 838,
    "duration": 0,
    "embed": null,
    "description": "string",
    "location": "string",
    "tags": [
      "string"
    ],
    "metadata": {},
    "focal_point_x": 0,
    "focal_point_y": 0,
    "tus_id": "string",
    "tus_data": null,
    "uploaded_on": "2019-12-03T00:10:15+00:00"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[Files](#schemafiles)|false|none||none|
|»» id|string|false|none||Unique identifier for the file.|
|»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»» type|string|false|none||MIME type of the file.|
|»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» created_on|string(date-time)|false|none||When the file was created.|
|»» modified_by|string(uuid)¦null|false|none||none|
|»» modified_on|string(timestamp)|false|none||none|
|»» charset|string¦null|false|none||Character set of the file.|
|»» filesize|integer|false|none||Size of the file in bytes.|
|»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»» embed|string¦null|false|none||Where the file was embedded from.|
|»» description|string¦null|false|none||Description for the file.|
|»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»» focal_point_x|integer¦null|false|none||none|
|»» focal_point_y|integer¦null|false|none||none|
|»» tus_id|string¦null|false|none||none|
|»» tus_data|null|false|none||none|
|»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdupdateFiles"></a>

## PATCH Update Multiple Files

PATCH /files

Update multiple files at the same time.

> Body Parameters

```json
{
  "data": {
    "data": "string"
  },
  "keys": [
    "string"
  ]
}
```

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|limit|query|integer| no |A limit on the number of objects that are returned.|
|meta|query|string| no |What metadata to return in the response.|
|offset|query|integer| no |How many items to skip when fetching data.|
|sort|query|array[string]| no |How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.|
|filter|query|string| no |Select items in collection by given conditions.|
|search|query|string| no |Filter by items that contain the given search query in one of their fields.|
|body|body|object| no |none|
|» data|body|object| no |none|
|»» data|body|string| no |none|
|» keys|body|[string]| no |none|

#### Description

**sort**: How to sort the returned items. `sort` is a CSV of fields used to sort the fetched items. Sorting defaults to ascending (ASC) order but a minus sign (` - `) can be used to reverse this to descending (DESC) order. Fields are prioritized by their order in the CSV. You can also use a ` ? ` to sort randomly.

> Response Examples

> 200 Response

```json
{
  "data": [
    {
      "id": "8cbb43fe-4cdf-4991-8352-c461779cec02",
      "storage": "local",
      "filename_disk": "a88c3b72-ac58-5436-a4ec-b2858531333a.jpg",
      "filename_download": "avatar.jpg",
      "title": "User Avatar",
      "type": "image/jpeg",
      "folder": null,
      "uploaded_by": "63716273-0f29-4648-8a2a-2af2948f6f78",
      "created_on": "2019-12-03T00:10:15+00:00",
      "modified_by": "e8d4374d-93a1-4e98-a6c6-fdcf00c5059f",
      "modified_on": "string",
      "charset": "binary",
      "filesize": 137862,
      "width": 800,
      "height": 838,
      "duration": 0,
      "embed": null,
      "description": "string",
      "location": "string",
      "tags": [
        "string"
      ],
      "metadata": {},
      "focal_point_x": 0,
      "focal_point_y": 0,
      "tus_id": "string",
      "tus_data": null,
      "uploaded_on": "2019-12-03T00:10:15+00:00"
    }
  ],
  "meta": {
    "total_count": 0,
    "filter_count": 0
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[[Files](#schemafiles)]|false|none||none|
|»» id|string|false|none||Unique identifier for the file.|
|»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»» type|string|false|none||MIME type of the file.|
|»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» created_on|string(date-time)|false|none||When the file was created.|
|»» modified_by|string(uuid)¦null|false|none||none|
|»» modified_on|string(timestamp)|false|none||none|
|»» charset|string¦null|false|none||Character set of the file.|
|»» filesize|integer|false|none||Size of the file in bytes.|
|»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»» embed|string¦null|false|none||Where the file was embedded from.|
|»» description|string¦null|false|none||Description for the file.|
|»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»» focal_point_x|integer¦null|false|none||none|
|»» focal_point_y|integer¦null|false|none||none|
|»» tus_id|string¦null|false|none||none|
|»» tus_data|null|false|none||none|
|»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|
|» meta|[x-metadata](#schemax-metadata)|false|none||none|
|»» total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|»» filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdgetFile"></a>

## GET Retrieve a Files

GET /files/{id}

Retrieve a single file by unique identifier.

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|string| yes |Unique identifier for the object.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": "8cbb43fe-4cdf-4991-8352-c461779cec02",
    "storage": "local",
    "filename_disk": "a88c3b72-ac58-5436-a4ec-b2858531333a.jpg",
    "filename_download": "avatar.jpg",
    "title": "User Avatar",
    "type": "image/jpeg",
    "folder": null,
    "uploaded_by": "63716273-0f29-4648-8a2a-2af2948f6f78",
    "created_on": "2019-12-03T00:10:15+00:00",
    "modified_by": "e8d4374d-93a1-4e98-a6c6-fdcf00c5059f",
    "modified_on": "string",
    "charset": "binary",
    "filesize": 137862,
    "width": 800,
    "height": 838,
    "duration": 0,
    "embed": null,
    "description": "string",
    "location": "string",
    "tags": [
      "string"
    ],
    "metadata": {},
    "focal_point_x": 0,
    "focal_point_y": 0,
    "tus_id": "string",
    "tus_data": null,
    "uploaded_on": "2019-12-03T00:10:15+00:00"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[Files](#schemafiles)|false|none||none|
|»» id|string|false|none||Unique identifier for the file.|
|»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»» type|string|false|none||MIME type of the file.|
|»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» created_on|string(date-time)|false|none||When the file was created.|
|»» modified_by|string(uuid)¦null|false|none||none|
|»» modified_on|string(timestamp)|false|none||none|
|»» charset|string¦null|false|none||Character set of the file.|
|»» filesize|integer|false|none||Size of the file in bytes.|
|»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»» embed|string¦null|false|none||Where the file was embedded from.|
|»» description|string¦null|false|none||Description for the file.|
|»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»» focal_point_x|integer¦null|false|none||none|
|»» focal_point_y|integer¦null|false|none||none|
|»» tus_id|string¦null|false|none||none|
|»» tus_data|null|false|none||none|
|»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

<a id="opIdupdateFile"></a>

## PATCH Update a File

PATCH /files/{id}

Update an existing file, and/or replace it's file contents.

> Body Parameters

```
string

```

### Params

|Name|Location|Type|Required|Description|
|---|---|---|---|---|
|id|path|string| yes |Unique identifier for the object.|
|fields|query|array[string]| no |Control what fields are being returned in the object.|
|meta|query|string| no |What metadata to return in the response.|
|body|body|string| no |none|

> Response Examples

> 200 Response

```json
{
  "data": {
    "id": "8cbb43fe-4cdf-4991-8352-c461779cec02",
    "storage": "local",
    "filename_disk": "a88c3b72-ac58-5436-a4ec-b2858531333a.jpg",
    "filename_download": "avatar.jpg",
    "title": "User Avatar",
    "type": "image/jpeg",
    "folder": null,
    "uploaded_by": "63716273-0f29-4648-8a2a-2af2948f6f78",
    "created_on": "2019-12-03T00:10:15+00:00",
    "modified_by": "e8d4374d-93a1-4e98-a6c6-fdcf00c5059f",
    "modified_on": "string",
    "charset": "binary",
    "filesize": 137862,
    "width": 800,
    "height": 838,
    "duration": 0,
    "embed": null,
    "description": "string",
    "location": "string",
    "tags": [
      "string"
    ],
    "metadata": {},
    "focal_point_x": 0,
    "focal_point_y": 0,
    "tus_id": "string",
    "tus_data": null,
    "uploaded_on": "2019-12-03T00:10:15+00:00"
  }
}
```

### Responses

|HTTP Status Code |Meaning|Description|Data schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Error: Unauthorized request|Inline|

### Responses Data Schema

HTTP Status Code **200**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» data|[Files](#schemafiles)|false|none||none|
|»» id|string|false|none||Unique identifier for the file.|
|»» storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|»» filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|»» filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|»» title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|»» type|string|false|none||MIME type of the file.|
|»» folder|null|false|none||Virtual folder where this file resides in.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» uploaded_by|any|false|none||Who uploaded the file.|

*oneOf*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|string|false|none||none|

*xor*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»»» *anonymous*|object|false|none||none|

*continued*

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|»» created_on|string(date-time)|false|none||When the file was created.|
|»» modified_by|string(uuid)¦null|false|none||none|
|»» modified_on|string(timestamp)|false|none||none|
|»» charset|string¦null|false|none||Character set of the file.|
|»» filesize|integer|false|none||Size of the file in bytes.|
|»» width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|»» height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|»» duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|»» embed|string¦null|false|none||Where the file was embedded from.|
|»» description|string¦null|false|none||Description for the file.|
|»» location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|»» tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|»» metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|»» focal_point_x|integer¦null|false|none||none|
|»» focal_point_y|integer¦null|false|none||none|
|»» tus_id|string¦null|false|none||none|
|»» tus_data|null|false|none||none|
|»» uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|

HTTP Status Code **401**

|Name|Type|Required|Restrictions|Title|description|
|---|---|---|---|---|---|
|» error|object|false|none||none|
|»» code|integer(int64)|false|none||none|
|»» message|string|false|none||none|

# Data Schema

<h2 id="tocS_Query">Query</h2>

<a id="schemaquery"></a>
<a id="schema_Query"></a>
<a id="tocSquery"></a>
<a id="tocsquery"></a>

```json
{
  "fields": [
    "*",
    "*.*"
  ],
  "filter": {
    "<field>": {
      "<operator>": "<value>"
    }
  },
  "search": "string",
  "sort": [
    "-date_created"
  ],
  "limit": 0,
  "offset": 0,
  "page": 0,
  "deep": {
    "related_articles": {
      "_limit": 3
    }
  }
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|fields|[string]|false|none||Control what fields are being returned in the object.|
|filter|object|false|none||none|
|search|string|false|none||Filter by items that contain the given search query in one of their fields.|
|sort|[string]|false|none||How to sort the returned items.|
|limit|number|false|none||Set the maximum number of items that will be returned|
|offset|number|false|none||How many items to skip when fetching data.|
|page|number|false|none||Cursor for use in pagination. Often used in combination with limit.|
|deep|object|false|none||Deep allows you to set any of the other query parameters on a nested relational dataset.|

<h2 id="tocS_x-metadata">x-metadata</h2>

<a id="schemax-metadata"></a>
<a id="schema_x-metadata"></a>
<a id="tocSx-metadata"></a>
<a id="tocsx-metadata"></a>

```json
{
  "total_count": 0,
  "filter_count": 0
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|total_count|integer|false|none||Returns the total item count of the collection you're querying.|
|filter_count|integer|false|none||Returns the item count of the collection you're querying, taking the current filter/search parameters into account.|

<h2 id="tocS_ItemsArticles">ItemsArticles</h2>

<a id="schemaitemsarticles"></a>
<a id="schema_ItemsArticles"></a>
<a id="tocSitemsarticles"></a>
<a id="tocsitemsarticles"></a>

```json
{
  "id": 0,
  "status": "string",
  "sort": 0,
  "user_created": "ab6120ca-a162-455c-af0b-743437e6156c",
  "date_created": "string",
  "user_updated": "c26bf67c-3e61-40d1-9cb9-8550c26cadc8",
  "date_updated": "string",
  "title": "string",
  "thumbnail": "dec11f24-4767-4257-ac7d-bde137bc173e",
  "content": null,
  "category": 0,
  "slug": "string",
  "summary": "string",
  "files": "string",
  "tags": "string"
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|status|string|false|none||none|
|sort|integer¦null|false|none||none|
|user_created|string(uuid)¦null|false|none||none|
|date_created|string(timestamp)¦null|false|none||none|
|user_updated|string(uuid)¦null|false|none||none|
|date_updated|string(timestamp)¦null|false|none||none|
|title|string|true|none||none|
|thumbnail|null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|string(uuid)|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[Files](#schemafiles)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|content|null|false|none||none|
|category|null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|integer|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|slug|string¦null|false|none||none|
|summary|string¦null|false|none||none|
|files|string¦null|false|none||none|
|tags|string¦null|false|none||none|

<h2 id="tocS_ItemsCategories">ItemsCategories</h2>

<a id="schemaitemscategories"></a>
<a id="schema_ItemsCategories"></a>
<a id="tocSitemscategories"></a>
<a id="tocsitemscategories"></a>

```json
{
  "id": 0,
  "name": "string",
  "slug": "string",
  "parent_id": 0,
  "order": 0
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|name|string|true|none||none|
|slug|string¦null|false|none||none|
|parent_id|null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|integer|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|order|integer|false|none||none|

<h2 id="tocS_ItemsDocuments">ItemsDocuments</h2>

<a id="schemaitemsdocuments"></a>
<a id="schema_ItemsDocuments"></a>
<a id="tocSitemsdocuments"></a>
<a id="tocsitemsdocuments"></a>

```json
{
  "id": 0,
  "title": "string",
  "file": "00bd29cf-1ab3-4825-b15f-d80a4a0e1cbb",
  "description": "string",
  "category": 0,
  "document_number": "string",
  "effective_date": "2019-08-24",
  "sub_category": 0,
  "agency_id": 0,
  "document_type_id": 0,
  "tags": "string"
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|title|string|true|none||none|
|file|null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|string(uuid)|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[Files](#schemafiles)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|description|string¦null|false|none||none|
|category|null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|integer|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|document_number|string¦null|false|none||none|
|effective_date|string(date)¦null|false|none||none|
|sub_category|null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|integer|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[ItemsSubCategory](#schemaitemssubcategory)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|agency_id|null|false|none||Cơ quan ban hành|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|integer|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[ItemsIssuingAgency](#schemaitemsissuingagency)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|document_type_id|null|false|none||Loại văn bản|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|integer|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[ItemsDocumentType](#schemaitemsdocumenttype)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|tags|string¦null|false|none||none|

<h2 id="tocS_ItemsVideos">ItemsVideos</h2>

<a id="schemaitemsvideos"></a>
<a id="schema_ItemsVideos"></a>
<a id="tocSitemsvideos"></a>
<a id="tocsitemsvideos"></a>

```json
{
  "id": 0,
  "title": "string",
  "link": "string",
  "thumbnail": "dec11f24-4767-4257-ac7d-bde137bc173e",
  "description": "string",
  "category": 0,
  "tags": "string"
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|title|string|true|none||none|
|link|string¦null|false|none||none|
|thumbnail|null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|string(uuid)|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[Files](#schemafiles)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|description|string¦null|false|none||none|
|category|null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|integer|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|tags|string¦null|false|none||none|

<h2 id="tocS_ItemsTags">ItemsTags</h2>

<a id="schemaitemstags"></a>
<a id="schema_ItemsTags"></a>
<a id="tocSitemstags"></a>
<a id="tocsitemstags"></a>

```json
{
  "id": 0,
  "name": "string",
  "slug": "string"
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|name|string|true|none||none|
|slug|string¦null|false|none||none|

<h2 id="tocS_ItemsSubCategory">ItemsSubCategory</h2>

<a id="schemaitemssubcategory"></a>
<a id="schema_ItemsSubCategory"></a>
<a id="tocSitemssubcategory"></a>
<a id="tocsitemssubcategory"></a>

```json
{
  "id": 0,
  "sub_name": "string",
  "category_id": 0,
  "slug": "string"
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|sub_name|string¦null|false|none||none|
|category_id|null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|integer|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[ItemsCategories](#schemaitemscategories)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|slug|string¦null|false|none||none|

<h2 id="tocS_ItemsDocumentType">ItemsDocumentType</h2>

<a id="schemaitemsdocumenttype"></a>
<a id="schema_ItemsDocumentType"></a>
<a id="tocSitemsdocumenttype"></a>
<a id="tocsitemsdocumenttype"></a>

```json
{
  "id": 0,
  "document_type_name": "string"
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|document_type_name|string¦null|false|none||none|

<h2 id="tocS_ItemsIssuingAgency">ItemsIssuingAgency</h2>

<a id="schemaitemsissuingagency"></a>
<a id="schema_ItemsIssuingAgency"></a>
<a id="tocSitemsissuingagency"></a>
<a id="tocsitemsissuingagency"></a>

```json
{
  "id": 0,
  "agency_name": "string"
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|agency_name|string¦null|false|none||none|

<h2 id="tocS_ItemsFeaturedArticles">ItemsFeaturedArticles</h2>

<a id="schemaitemsfeaturedarticles"></a>
<a id="schema_ItemsFeaturedArticles"></a>
<a id="tocSitemsfeaturedarticles"></a>
<a id="tocsitemsfeaturedarticles"></a>

```json
{
  "id": 0,
  "title": "string",
  "articles": [
    0
  ]
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|title|string¦null|false|none||none|
|articles|[oneOf]¦null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|integer|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[ItemsFeaturedArticlesArticles](#schemaitemsfeaturedarticlesarticles)|false|none||none|

<h2 id="tocS_ItemsFeaturedArticlesArticles">ItemsFeaturedArticlesArticles</h2>

<a id="schemaitemsfeaturedarticlesarticles"></a>
<a id="schema_ItemsFeaturedArticlesArticles"></a>
<a id="tocSitemsfeaturedarticlesarticles"></a>
<a id="tocsitemsfeaturedarticlesarticles"></a>

```json
{
  "id": 0,
  "featured_articles_id": 0,
  "articles_id": 0
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|id|integer|false|none||none|
|featured_articles_id|null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|integer|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[ItemsFeaturedArticles](#schemaitemsfeaturedarticles)|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|articles_id|null|false|none||none|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|integer|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|[ItemsArticles](#schemaitemsarticles)|false|none||none|

<h2 id="tocS_Files">Files</h2>

<a id="schemafiles"></a>
<a id="schema_Files"></a>
<a id="tocSfiles"></a>
<a id="tocsfiles"></a>

```json
{
  "id": "8cbb43fe-4cdf-4991-8352-c461779cec02",
  "storage": "local",
  "filename_disk": "a88c3b72-ac58-5436-a4ec-b2858531333a.jpg",
  "filename_download": "avatar.jpg",
  "title": "User Avatar",
  "type": "image/jpeg",
  "folder": null,
  "uploaded_by": "63716273-0f29-4648-8a2a-2af2948f6f78",
  "created_on": "2019-12-03T00:10:15+00:00",
  "modified_by": "e8d4374d-93a1-4e98-a6c6-fdcf00c5059f",
  "modified_on": "string",
  "charset": "binary",
  "filesize": 137862,
  "width": 800,
  "height": 838,
  "duration": 0,
  "embed": null,
  "description": "string",
  "location": "string",
  "tags": [
    "string"
  ],
  "metadata": {},
  "focal_point_x": 0,
  "focal_point_y": 0,
  "tus_id": "string",
  "tus_data": null,
  "uploaded_on": "2019-12-03T00:10:15+00:00"
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|id|string|false|none||Unique identifier for the file.|
|storage|string|false|none||Where the file is stored. Either `local` for the local filesystem or the name of the storage adapter (for example `s3`).|
|filename_disk|string|false|none||Name of the file on disk. By default, Directus uses a random hash for the filename.|
|filename_download|string|false|none||How you want to the file to be named when it's being downloaded.|
|title|string|false|none||Title for the file. Is extracted from the filename on upload, but can be edited by the user.|
|type|string|false|none||MIME type of the file.|
|folder|null|false|none||Virtual folder where this file resides in.|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|string|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|object|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|uploaded_by|any|false|none||Who uploaded the file.|

oneOf

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|string|false|none||none|

xor

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|» *anonymous*|object|false|none||none|

continued

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|created_on|string(date-time)|false|none||When the file was created.|
|modified_by|string(uuid)¦null|false|none||none|
|modified_on|string(timestamp)|false|none||none|
|charset|string¦null|false|none||Character set of the file.|
|filesize|integer|false|none||Size of the file in bytes.|
|width|integer¦null|false|none||Width of the file in pixels. Only applies to images.|
|height|integer¦null|false|none||Height of the file in pixels. Only applies to images.|
|duration|integer¦null|false|none||Duration of the file in seconds. Only applies to audio and video.|
|embed|string¦null|false|none||Where the file was embedded from.|
|description|string¦null|false|none||Description for the file.|
|location|string¦null|false|none||Where the file was created. Is automatically populated based on Exif data for images.|
|tags|[string]¦null|false|none||Tags for the file. Is automatically populated based on Exif data for images.|
|metadata|object¦null|false|none||IPTC, Exif, and ICC metadata extracted from file|
|focal_point_x|integer¦null|false|none||none|
|focal_point_y|integer¦null|false|none||none|
|tus_id|string¦null|false|none||none|
|tus_data|null|false|none||none|
|uploaded_on|string(date-time)|false|none||When the file was last uploaded/replaced.|

<h2 id="tocS_NotFoundError">NotFoundError</h2>

<a id="schemanotfounderror"></a>
<a id="schema_NotFoundError"></a>
<a id="tocSnotfounderror"></a>
<a id="tocsnotfounderror"></a>

```json
{
  "error": {
    "code": 0,
    "message": "string"
  }
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|error|object|false|none||none|
|» code|integer(int64)|false|none||none|
|» message|string|false|none||none|

<h2 id="tocS_UnauthorizedError">UnauthorizedError</h2>

<a id="schemaunauthorizederror"></a>
<a id="schema_UnauthorizedError"></a>
<a id="tocSunauthorizederror"></a>
<a id="tocsunauthorizederror"></a>

```json
{
  "error": {
    "code": 0,
    "message": "string"
  }
}

```

### Attribute

|Name|Type|Required|Restrictions|Title|Description|
|---|---|---|---|---|---|
|error|object|false|none||none|
|» code|integer(int64)|false|none||none|
|» message|string|false|none||none|

