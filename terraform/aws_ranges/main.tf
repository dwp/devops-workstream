/*

Module for fetching AWS IP address ranges.

This is useful for e.g. when you want to restrict security
group rules to a limited set of ingress ranges but ALSO want to be able to permit
ingress from Route53 health checkers. Or when you're consuming an
api you know is hosted on EC2 in London and want to prevent
HTTP egress to other ranges.

Requires :

  `jq` program installed
  `curl` program installed

*/

variable "type" {
  type = "string"
  description = <<DESC
The type of range required.

Available values are

"AMAZON"
"CLOUDFRONT"
"CODEBUILD"
"EC2"
"ROUTE53"
"ROUTE53_HEALTHCHECKS"
"S3"

You can get the current list by doing : 

`curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq '.prefixes[] | .service' | sort | uniq`

DESC
}

variable "region" {
  type = "string"
  default = "null"
  description = "The AWS region the required ranges are in. Optional."
}

data "external" "ranges" {
  program = ["bash", "${path.module}/aws_ranges.sh"]
  query = {
    type = "${var.type}"
    region = "${var.region}"
  }
}

output "ranges" {
  /* list */
  value = "${split("|", data.external.ranges.result.ranges)}"
}
