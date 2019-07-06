# httpclient-swift
<p>Provides a convenient way of making HTTP requests and parsing a JSON result to a data model.</p>

## Usage

<p>Minimal example, perform a request to an URL and decode a JSON response to an object.</p>

Target object class/struct conforms to `Codable`:

```
class ExampleClass: Codable {
    var test: String
}
```

Perform a GET reguest from your code:

1. Import the client
`import HttpClient`

2. Perform the request and initiate and instance of `ExampleClass` with response:
```
let client = HttpClient()
let headers = [HCConstants.accept : HCConstants.applicationJson]
        
client.httpRequest(url: "YOUR URL",
                   httpMethod: .get,
                   outType: ExampleClass.self,
                   headers: headers) { (response) in
    guard let result = response else {
        print("Error")
        return
    }

    switch (result) {
    case .success(_, let result):
        print("all good, do something with 'result'")
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
* url
* method type
* type of response object
* headers
* request body
* cache policy
* timeout in seconds
