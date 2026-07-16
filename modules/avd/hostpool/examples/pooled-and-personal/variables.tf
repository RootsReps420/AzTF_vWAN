variable "resource_group_name" {
  description = "Resource group into which both host pools are deployed."
  type        = string
}

variable "tags" {
  description = "Tags applied to both host pools."
  type        = map(string)
  default     = {}
}
