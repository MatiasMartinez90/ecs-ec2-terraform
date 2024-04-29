# --- ECS Capacity Provider ---

resource "aws_ecs_capacity_provider" "main" {
  name = "demo-ecs-ec2"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs.arn
    managed_termination_protection = "DISABLED"  # Esto determina si el grupo de Auto Scaling tiene protección de terminación administrada

    managed_scaling {
      maximum_scaling_step_size = 4   # Para que vaya agregando instancias al cluster de 4 a la vez (pra escalar mas rapido)
      minimum_scaling_step_size = 1   # Para que vaya quitando instancias del cluster de 1 a la vez
      status                    = "ENABLED"
      target_capacity           = 100 # La utilización de la capacidad objetivo como porcentaje para el proveedor de capacidad
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = [aws_ecs_capacity_provider.main.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    base              = 1
    weight            = 100
  }
}