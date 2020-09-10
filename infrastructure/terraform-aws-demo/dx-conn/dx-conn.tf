#exercise Direct Connect
resource "aws_dx_connection" "exercise_dx" {
  name      = var.dx_name
  bandwidth = var.dx_bandwidth
  location  = var.dx_location
  tags      = var.dx_tags
}