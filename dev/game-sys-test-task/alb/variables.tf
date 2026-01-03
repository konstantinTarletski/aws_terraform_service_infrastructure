variable "alb_port_mappings" {
  type = map(object({
    path_pattern = string
    priority     = number
    health_check = string
    is_default   = bool
  }))
 // default = { "8080" = { path_pattern = "/*", priority = 10, health_check = "/", is_default = true } }
  default       = { "8815" = { path_pattern = "/*", priority = 10, health_check = "/swagger-ui.html", is_default = true } }
}
