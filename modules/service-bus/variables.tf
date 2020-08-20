variable location {
  description = "Region where resource group needs to be created"
  default     = "unknown"
}

variable client_name {
  description = "This determines the client. Ex - RegEd"
  default     = "unknown"
}

variable environment {
  description = "Name of envorioment. Example: dev, qa, stg"
}

variable owner {
  description = "POC for this project"
  default     = ""
}

variable vendor {
  description = "Service provider responsible for project"
  default     = "Globallogic"
}

variable "role" {
  default = ""
}

variable "topics" {
  type        = list(any)
  default     = []
}

variable resource_group_name {
  description = "Default resource group name that the network will be created in."
}

variable creator {
  description = "Person/Team responsible for resource"
  default     = "gl-devops"
}

variable application {
  description = "This should be name of application that is hosted on the platform. "
  default     = ""
}

variable tags {
  description = "This lists the tags associated with the resource"
  type        = map(string)
}
