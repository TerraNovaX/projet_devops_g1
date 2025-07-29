module "cdn" {
  source     = "terraform-aws-modules/cloudfront/aws"
  depends_on = [aws_s3_bucket.main]

  comment             = "DevOps course project Cloudfront Distribution"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = var.price_class
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    devops_project_front_s3 = "My Cloudfront Can Access to S3"
  }

  origin = {

    something = {
      domain_name = aws_s3_bucket.main.bucket_regional_domain_name
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }

    devops_project_front_s3 = {
      domain_name = aws_s3_bucket.main.bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = local.s3_origin_id
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = var.viewer_protocol_policy

    allowed_methods = var.allowed_methods
    cached_methods  = var.cached_methods
    min_ttl         = 3600
    default_ttl     = 5400
    max_ttl         = 7200
    query_string    = false
    compress        = true
  }

  default_root_object = var.index_file
  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  web_acl_id = ""
}

resource "aws_cloudfront_origin_access_identity" "origin_s3" {
  comment = var.cloudfront_origin_access_identity
}