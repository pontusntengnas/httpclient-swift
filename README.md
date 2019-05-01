# httpclient-swift
<p>Provides a convenient way of making HTTP requests and parsing a JSON result to a data model.</p>

## Usage

<p>Minimal example, perform a request to an URL and decode a JSON response to an object.</p>

Target object class/struct conforms to `CodableJson`:

```
class ExampleClass: CodableJson {
    var test: String
}
```

Perform a GET reguest from your code:

1. Import the client
`import HttpClient`

2. Perform the request and initiate and instance of `ExampleClass` with response:
```
let client = HttpClient()

client.httpRequest(url: "<YOUR_URL>", httpMethod: .get) { (response) in
    guard let result = response else {
        print("Error")
        return
    }

    switch (result) {
    case .success(_, let data):
        if let exampleObject = ExampleClass(json: data) {
            print("Got our object!")
        } else {
            print("Failed JSON decode")
        }
    case .httpFailure(let status):
        print("HttpError, status: \(status)")
    case .failure(let reason):
        print(reason)
    case .badInput(let reason):
        print(reason)
    }
}
```

## API

Supported HTTP methods:
* GET
* POST
* PUT
* DELETE

httpRequest() accepts:
* Url
* method type
* headers
* request body

## TODO: 
* Support timeout and cache policy
