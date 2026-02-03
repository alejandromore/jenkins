resource "huaweicloud_elb_listener" "this" {
  name            = var.name
  protocol        = var.protocol
  port            = var.port
  loadbalancer_id = var.elb_id
}
