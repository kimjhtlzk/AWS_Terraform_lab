resource "aws_flow_log" "example" {
  tags = {
      Name = var.flow_log_name
  }

  vpc_id                    = var.vpc_name

  log_destination_type      = "s3" # s3 arn
  log_destination           = var.s3_arn

  traffic_type              = var.traffic_type # "ALL" or "ACCEPT" or "REJECT"
  max_aggregation_interval  = var.max_aggregation_interval # 600 or 60

  destination_options {
    file_format        = "plain-text" # "plain-text" or "parquet"
    per_hour_partition = false
  }
}

