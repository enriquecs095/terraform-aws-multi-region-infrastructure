
locals {
  list_of_rules_cidr = toset(flatten([
    for sg in var.security_groups : [
      for rules in sg.list_of_rules_cidr : [{
        name : rules.name
        type : rules.type
        description : rules.description,
        protocol : rules.protocol,
        from_port : rules.from_port,
        to_port : rules.to_port,
        cidr_blocks : rules.cidr_blocks,
        security_group_name : sg.name
      }]
  ]]))

  list_of_rules_source_security_groups = toset(flatten([
    for sg in var.security_groups : [
      for rules in sg.list_of_rules_source_security_groups : [{
        name : rules.name
        type : rules.type
        description : rules.description,
        protocol : rules.protocol,
        from_port : rules.from_port,
        to_port : rules.to_port,
        source_security_group_name : rules.source_security_group_name
        security_group_name : sg.name
      }]
  ]]))
}




