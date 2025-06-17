locals {
  
  metric_alarm = {
    # --------------------------------------------------------------------------
    seoul = {
      ##########################################################################
      # EKS alarm
      ##########################################################################
#      EKS-node_cpu_utilization = {
#        alarm_description   = "노드 CPU 사용률 (80%) 이상 사용시 알림 발생됩니다."
#        comparison_operator = "GreaterThanThreshold"
#        threshold           = 80
#        metric_query = [
#          {
#            expression  = "FIRST(q1)"
#            id          = "e1"
#            period      = "0"
#            return_data = "true"
#          },
#          {
#            expression  = "SELECT MAX(node_cpu_utilization) FROM SCHEMA(ContainerInsights, ClusterName,InstanceId,NodeName) GROUP BY ClusterName, NodeName, InstanceId ORDER BY MAX() DESC" 
#            id          = "q1"
#            period      = "60"
#            return_data = "false"
#          }
#        ]          
#      }
#      EKS-node_memory_utilization = {
#        alarm_description   = "노드 메모리 사용률 (80%) 이상 사용시 알림 발생됩니다."
#        comparison_operator = "GreaterThanThreshold"
#        threshold           = 80
#        metric_query = [
#          {
#            expression  = "FIRST(q1)"
#            id          = "e1"
#            period      = "0"
#            return_data = "true"
#          },
#          {
#            expression  = "SELECT MAX(node_memory_utilization) FROM SCHEMA(ContainerInsights, ClusterName, InstanceId, NodeName) GROUP BY NodeName,InstanceId,ClusterName ORDER BY MAX() DESC" 
#            id          = "q1"
#            period      = "60"
#            return_data = "false"
#          }
#        ]          
#      }
    }
    # --------------------------------------------------------------------------
    tokyo = {    
    }
  }
}
module "seoul_metric_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  for_each  = local.metric_alarm.seoul

  providers = {
    aws = aws.seoul
  }

  alarm_name          = each.key
  alarm_description   = each.value.alarm_description
  comparison_operator = each.value.comparison_operator
  threshold           = each.value.threshold
  evaluation_periods  = try(each.value.evaluation_periods, "1")
  datapoints_to_alarm = try(each.value.datapoints_to_alarm, "1")
  metric_query        = each.value.metric_query

  alarm_actions = [ aws_sns_topic.seoul_sns_topic.id ]
}

module "tokyo_metric_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  for_each  = local.metric_alarm.tokyo

  providers = {
    aws = aws.tokyo
  }

  alarm_name          = each.key
  alarm_description   = each.value.alarm_description
  comparison_operator = each.value.comparison_operator
  threshold           = each.value.threshold
  evaluation_periods  = try(each.value.evaluation_periods, "1")
  datapoints_to_alarm = try(each.value.datapoints_to_alarm, "1")
  metric_query        = each.value.metric_query

  alarm_actions = [ aws_sns_topic.tokyo_sns_topic.id ]
}

##########################################################################
# Default SNS 
##########################################################################
resource "aws_sns_topic" "seoul_sns_topic" {
  provider        = aws.seoul
  name            = "c-sns"
}

resource "aws_sns_topic" "tokyo_sns_topic" {
  provider        = aws.tokyo
  name            = "cs-sns"
}
##########################################################################
# Chatbot Slack & Chatbot role
##########################################################################
resource "awscc_chatbot_slack_channel_configuration" "chatbot_slack_channel" {

  configuration_name = "ffff-chatbot-slack"
  iam_role_arn       = awscc_iam_role.chatbot_role.arn
  # Slack id 값은 구성된 slack url 정보를 참고하면 됩니다.
  # slack link : https://app.slack.com/client/ffdfd/sfsdfsd
  slack_workspace_id = "sdfsf4654" # infra_monitor
  slack_channel_id   = "sdfsf4654" # live-aws-monitoring
  guardrail_policies = ["arn:aws:iam::aws:policy/job-function/SystemAdministrator"]
    sns_topic_arns     = [
    aws_sns_topic.seoul_sns_topic.arn,
    aws_sns_topic.tokyo_sns_topic.arn
  ]
}

resource "awscc_iam_role" "chatbot_role" {
  role_name          = "ChatBot-Channel-Role"
  assume_role_policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "chatbot.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSResourceExplorerReadOnlyAccess"]
}
##########################################################################