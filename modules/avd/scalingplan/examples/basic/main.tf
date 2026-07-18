# Basic example — a personal scaling plan for PERS host pools, with one personal
# schedule (via azapi) and the plan associated to a host pool.

module "scalingplan" {
  source = "../.."

  name                = "pers-uks"
  resource_group_name = "rg-vdi-pers-dev"
  location            = "uksouth"
  subscription_id     = "vdi"
  environment         = "dev"
  unique_id           = "01"

  friendly_name = "PERS UK South"
  time_zone     = "GMT Standard Time"

  host_pool_associations = {
    "pers-pool" = {
      hostpool_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-vdi-pers-dev/providers/Microsoft.DesktopVirtualization/hostPools/uks-vdi-vdhp-pers-01"
      scaling_plan_enabled = true
    }
  }

  personal_schedules = {
    "weekdays" = {
      properties = {
        daysOfWeek                        = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        rampUpStartTime                   = { hour = 7, minute = 0 }
        rampUpAutoStartHosts              = "WithAssignedUser"
        rampUpStartVMOnConnect            = "Enable"
        rampUpActionOnDisconnect          = "None"
        rampUpMinutesToWaitOnDisconnect   = 0
        rampUpActionOnLogoff              = "None"
        rampUpMinutesToWaitOnLogoff       = 0
        peakStartTime                     = { hour = 9, minute = 0 }
        peakStartVMOnConnect              = "Enable"
        peakActionOnDisconnect            = "None"
        peakMinutesToWaitOnDisconnect     = 0
        peakActionOnLogoff                = "None"
        peakMinutesToWaitOnLogoff         = 0
        rampDownStartTime                 = { hour = 18, minute = 0 }
        rampDownStartVMOnConnect          = "Enable"
        rampDownActionOnDisconnect        = "None"
        rampDownMinutesToWaitOnDisconnect = 0
        rampDownActionOnLogoff            = "Deallocate"
        rampDownMinutesToWaitOnLogoff     = 30
        offPeakStartTime                  = { hour = 20, minute = 0 }
        offPeakStartVMOnConnect           = "Enable"
        offPeakActionOnDisconnect         = "None"
        offPeakMinutesToWaitOnDisconnect  = 0
        offPeakActionOnLogoff             = "Deallocate"
        offPeakMinutesToWaitOnLogoff      = 30
      }
    }
  }

  tags = {
    "managed-by" = "terraform"
    environment  = "dev"
    workload     = "vdi-pers"
    repo         = "vdi-terraform"
  }
}

output "scaling_plan_id" {
  value = module.scalingplan.scaling_plan_id
}
