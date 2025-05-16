output "patients_tg_arn" {
  value = aws_lb_target_group.patients_tg.arn
}

output "appointments_tg_arn" {
  value = aws_lb_target_group.appointments_tg.arn
}
