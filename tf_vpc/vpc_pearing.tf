resource "aws_vpc_peering_connection" "owner_shs_acc" {
  peer_owner_id =  "82245624352"
  peer_vpc_id   =  "vpc-02346234652456"
  vpc_id        =  "vpc-04361362565645"
  tags = {
    product-name    = "vpc-peering-owner"
    owner-id        = ""
    owner-contact   = ""
    project         = "ak3"
    environment     = "shs"
    team            = "devops"
  }
}

resource "aws_vpc_peering_connection_accepter" "accepter_dev_acc" {
    provider = aws.dev_account
    vpc_peering_connection_id = aws_vpc_peering_connection.owner_shs_acc.id
    auto_accept = true                      
    tags = {
    product-name    = "vpc-peering-accepter"
    owner-id        = ""
    owner-contact   = ""
    project         = "ak3"
    environment     = "dev"
    team            = "devops"
  }
}

resource "aws_route" "shs_account" {
  route_table_id                        = "rtb-4527623473734w256"
  destination_cidr_block                = "10.2.0.0/16"
  vpc_peering_connection_id             = aws_vpc_peering_connection.owner_shs_acc.id
}

resource "aws_route" "dev_account" {
 provider = aws.dev_account
  route_table_id                        = "rtb-5276345684576894756fs"
  destination_cidr_block                = "10.1.0.0/16"
  vpc_peering_connection_id             = aws_vpc_peering_connection.owner_shs_acc.id
}