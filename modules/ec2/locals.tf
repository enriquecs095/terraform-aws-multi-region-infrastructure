locals {
  security_groups_list = flatten([
      for sg_instance in var.instance_data.security_groups : 
            var.security_groups_list["${sg_instance}_${var.environment}"]
  ])

}
