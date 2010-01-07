echo `hal-device | grep charge_level.percentage | awk '{print $3}'`%
