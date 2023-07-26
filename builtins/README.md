# Terraform Built-in Functions

Documentation:
https://developer.hashicorp.com/terraform/language/functions


Test Terraform Built-In function with the Terraform console

```console
terraform console
```

```console
> timestamp()
"2023-07-25T14:37:11Z"

> length("qwertyuiop1234567890")
20

> max(1,2,3,4,5,6,7,8,9,0)
9

> strcontains("terraform is awesome", "awesome")
true

> strcontains("terraform is awesome", "loosy")
false

> join("-", ["terraform", "is", "awesome"])
"terraform-is-awesome"

> split(",", "terraform,is,awesome")
[
  "foo",
  "bar",
  "baz",
]

> regex("[a-z]+", "09874509238475terraform23452345is64256453awesome098762345")
"terraform"

> length(regex("[a-z]+", "09874509238475terraform23452345is64256453awesome098762345"))
9

> regexall("[a-z]+", "09874509238475terraform23452345is64256453awesome098762345")
tolist([
  "terraform",
  "is",
  "awesome",
])

> regex("[a-z]+", "12345678900987654321123456789")
╷
│ Error: Error in function call
│ 
│   on <console-input> line 1:
│   (source code not available)
│ 
│ Call to function "regex" failed: pattern did not match any part of the given string.
╵

```