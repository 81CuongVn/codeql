// Stubs
class URLSession {
  class var shared: URLSession {
    return URLSession()
  }
  init(configuration: URLSessionConfiguration) {}
  init() {}
}

enum tls_protocol_version_t {
  case TLSv12
  case TLSv13
}

class URLSessionConfiguration {
  class var `default`:  URLSessionConfiguration {
    return URLSessionConfiguration()
  }
  var tlsMinimumSupportedProtocolVersion: tls_protocol_version_t = tls_protocol_version_t.TLSv12
}

/// Tests

func case_0() {
  URLSession(configuration: URLSessionConfiguration.default) // BAD
}


func case_1() {
  let config = URLSessionConfiguration.default
  URLSession(configuration: config) // BAD
}

func case_2() {
  let config = URLSessionConfiguration.default
  config.tlsMinimumSupportedProtocolVersion = tls_protocol_version_t.TLSv12
  URLSession(configuration: config) // BAD
}

func case_3() {
  let config = URLSessionConfiguration.default
  config.tlsMinimumSupportedProtocolVersion = tls_protocol_version_t.TLSv13
  URLSession(configuration: config) // GOOD
}
