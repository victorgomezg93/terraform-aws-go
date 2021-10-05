# alb.tf

resource "aws_alb" "main" {
  name            = "myapp-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "app" {
  name        = "myapp-target-group"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTPS"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTPS"
  certificate_arn    = "arn:aws:acm:us-east-1:206607556591:certificate/74a5e9d3-01da-4046-9553-1893c2dc3215"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}