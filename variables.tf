variable "emails" {
  description = "A collection of email addresses to allow access to applications."
  type = object({
    me = set(string)
    # Potential for additional categories of users in the future (e.g. "friends", "family", etc.)
  })
  validation {
    condition     = length([for email in var.emails.me : email if email != null]) > 0
    error_message = "At least one email address must be provided for 'me'."
  }
}

variable "idps" {
  description = "External identity provider configurations for Access policies."
  type = map(object({
    client_id     = string
    client_secret = string
  }))
  sensitive = true
  validation {
    condition     = alltrue([for required_provider in ["google"] : contains(keys(var.idps), required_provider)])
    error_message = "Required IdPs: ${join(", ", ["google"])}."
  }
}
