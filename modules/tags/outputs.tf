output "tags" {
  description = "Single merged tag map combining mandatory, platform, and additional tags. Pass directly to the `tags` argument on resources."
  value       = local.tags
}
