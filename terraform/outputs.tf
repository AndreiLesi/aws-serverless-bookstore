output "api_gateway_url" {
  value       = aws_api_gateway_deployment.bookstore_deployment.invoke_url
  description = "URL of the API Gateway endpoint"
}