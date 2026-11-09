moved {
    from = module.web_vpc
    to   = module.dev.module.web_vpc
}

moved {
    from = aws_security_group.web
    to   = module.dev.aws_security_group.web
}

moved {
    from = aws_security_group_rule.web_http_in
    to   = module.dev.aws_security_group_rule.web_http_in
}

moved {
    from = aws_security_group_rule.web_https_in
    to   = module.dev.aws_security_group_rule.web_https_in
}

moved {
    from = aws_security_group_rule.web_everything_out
    to   = module.dev.aws_security_group_rule.web_everything_out
}

moved {
    from = module.web_alb
    to   = module.dev.module.web_alb
}

moved {
    from = aws_lb_target_group.web
    to   = module.dev.aws_lb_target_group.web
}

moved {
    from = module.web_autoscaling
    to   = module.dev.module.web_autoscaling
}