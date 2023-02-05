# Host Zones

resource "aws_route53_zone" "master" {
  name = "example.com"
  provider = aws.master

  tags = merge(
    local.common_tags,
    {
      "Name" = "hosted_zone-mstr-ue1-rt53-001"
    },
    {
      "Environment" = "mstr"
    }
  )
}

resource "aws_route53_zone" "shs" {
  name = "tools.example.com"

  tags = merge(
    local.common_tags,
    {
      "Name" = "hosted_zone-shs-ue1-rt53-001"
    },
    {
      "Environment" = "shs"
    }
  )
}

resource "aws_route53_zone" "dev" {
  name = "dev.example.com"
  provider = aws.dev

  tags = merge(
    local.common_tags,
    {
      "Name" = "hosted_zone-dev-ue1-rt53-001"
    },
    {
      "Environment" = "dev"
    }
  )
}

# NS Records

resource "aws_route53_record" "dev-ns" {
  provider = aws.master
  zone_id = aws_route53_zone.master.zone_id
  name    = "dev.example.com"
  type    = "NS"
  ttl     = "60"
  records = aws_route53_zone.dev.name_servers
}

resource "aws_route53_record" "shs-ns" {
  provider = aws.master
  zone_id = aws_route53_zone.master.zone_id
  name    = "tools.example.com"
  type    = "NS"
  ttl     = "60"
  records = aws_route53_zone.shs.name_servers
}

# A Records

resource "aws_route53_record" "shs-a_001" {
  zone_id = aws_route53_zone.shs.zone_id
  name    = "jenkins.tools.example.com"
  type    = "A"
  ttl     = "60"
  records = ["ip"]
}

resource "aws_route53_record" "shs-a_002" {
  zone_id = aws_route53_zone.shs.zone_id
  name    = "plg.tools.example.com"
  type    = "A"
  ttl     = 60
  records = ["ip"]
}

resource "aws_route53_record" "shs-a_003" {
  zone_id = aws_route53_zone.shs.zone_id
  name    = "jfrog.tools.example.com"
  type    = "A"
  ttl     = 60
  records = ["ip"]
}

resource "aws_route53_record" "master-mx_001" {
  provider = aws.master
  zone_id = aws_route53_zone.master.zone_id
  name    = "example.com"
  type    = "MX"
  ttl     = 60
  records = ["0 akumoproject-com.mail.protection.outlook.com"]
}

resource "aws_route53_record" "master-txt_001" {
  provider = aws.master
  zone_id = aws_route53_zone.master.zone_id
  name    = "example.com"
  type    = "TXT"
  ttl     = 60
  records = ["v=spf1 include:spf.protection.outlook.com -all"]
}

resource "aws_route53_record" "master-cname_001" {
  provider = aws.master
  zone_id = aws_route53_zone.master.zone_id
  name    = "autodiscover.example.com"
  type    = "CNAME"
  ttl     = 60
  records = ["autodiscover.outlook.com"]
}